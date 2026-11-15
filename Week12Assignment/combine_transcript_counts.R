#!/usr/bin/env Rscript
#
# combine_transcript_counts.R
#
# Combine salmon quant.sf files into a count matrix using tximport.
# One script, two behaviors:
#
#   transcript : one row per transcript (transcript-level count matrix)
#   gene       : transcript counts summed per gene (gene-level count matrix)
#
# Both outputs include the gene name for every row (taken from the GTF file).
# Columns are named by the sample names in design.csv.
#
# Usage (everything after the level is optional; defaults match the Makefile):
#   Rscript src/combine_transcript_counts.R <transcript|gene> [design.csv] [counts_dir] [gtf] [output.csv]
#
# Examples:
#   Rscript src/combine_transcript_counts.R transcript
#       -> res/transcript_counts.csv
#   Rscript src/combine_transcript_counts.R gene
#       -> res/gene_counts_salmon.csv
#
# Expects salmon output at <counts_dir>/<sample>/quant.sf, e.g. counts/HBR_1/quant.sf

suppressPackageStartupMessages(library(tximport))

args <- commandArgs(trailingOnly = TRUE)
if (length(args) < 1 || length(args) > 5 || !(args[1] %in% c("transcript", "gene"))) {
  stop("Usage: Rscript combine_transcript_counts.R <transcript|gene> [design.csv] [counts_dir] [gtf] [output.csv]")
}
level <- args[1]
default_out <- if (level == "transcript") "res/transcript_counts.csv" else "res/gene_counts_salmon.csv"
defaults <- c(level, "design.csv", "counts", "gtf/chr22.gtf", default_out)
args <- c(args, defaults[(length(args) + 1):5])[1:5]
design_file <- args[2]
counts_dir  <- args[3]
gtf_file    <- args[4]
out_file    <- args[5]

# ---- Read the design file ---------------------------------------------------
design <- read.csv(design_file, stringsAsFactors = FALSE)
sample_col <- if ("sample" %in% names(design)) "sample" else names(design)[1]
samples <- design[[sample_col]]

files <- file.path(counts_dir, samples, "quant.sf")
names(files) <- samples
missing <- files[!file.exists(files)]
if (length(missing) > 0) {
  stop("Missing salmon output: ", paste(missing, collapse = ", "))
}

# ---- Transcript -> gene table from the GTF ----------------------------------
read_tx2gene <- function(gtf) {
  lines <- readLines(gtf)
  lines <- lines[!startsWith(lines, "#")]
  attrs <- vapply(strsplit(lines, "\t", fixed = TRUE),
                  function(x) if (length(x) >= 9) x[9] else NA_character_, "")
  attrs <- attrs[!is.na(attrs) & grepl("transcript_id", attrs)]
  get_attr <- function(a, key) {
    out <- rep(NA_character_, length(a))
    has <- grepl(paste0(key, ' "'), a)
    out[has] <- sub(paste0(".*", key, ' "([^"]+)".*'), "\\1", a[has])
    out
  }
  df <- data.frame(tx_id     = get_attr(attrs, "transcript_id"),
                   gene_id   = get_attr(attrs, "gene_id"),
                   gene_name = get_attr(attrs, "gene_name"),
                   stringsAsFactors = FALSE)
  df <- df[!duplicated(df$tx_id), ]
  df$gene_name[is.na(df$gene_name)] <- df$gene_id[is.na(df$gene_name)]
  df
}
tx2gene <- read_tx2gene(gtf_file)

# salmon IDs sometimes carry extra fields ("ENST...|ENSG...|...") or a
# version suffix that the GTF lacks. Strip them if the IDs don't match as-is.
quant_ids <- read.delim(files[1], stringsAsFactors = FALSE)$Name
clean_id <- function(x) sub("\\|.*$", "", x)
if (mean(clean_id(quant_ids) %in% tx2gene$tx_id) < 0.5) {
  tx2gene$tx_id <- sub("\\.[0-9]+$", "", tx2gene$tx_id)
  strip_version <- TRUE
} else {
  strip_version <- FALSE
}
match_id <- function(x) {
  x <- clean_id(x)
  if (strip_version) sub("\\.[0-9]+$", "", x) else x
}

# ---- Import with tximport ----------------------------------------------------
dir.create(dirname(out_file), showWarnings = FALSE, recursive = TRUE)

if (level == "transcript") {
  txi <- tximport(files, type = "salmon", txOut = TRUE, dropInfReps = TRUE)
  counts <- txi$counts
  ids <- rownames(counts)
  hit <- match(match_id(ids), tx2gene$tx_id)
  gene_id   <- tx2gene$gene_id[hit]
  gene_name <- tx2gene$gene_name[hit]
  result <- data.frame(transcript_id = ids, gene_id = gene_id, gene_name = gene_name,
                       round(counts, 2), check.names = FALSE, stringsAsFactors = FALSE)
} else {
  # Import per transcript, then sum counts per gene. Building the map from
  # salmon's own IDs makes sure they match the GTF IDs.
  txi_tx <- tximport(files, type = "salmon", txOut = TRUE, dropInfReps = TRUE)
  map <- data.frame(
    TXNAME = rownames(txi_tx$counts),
    GENEID = tx2gene$gene_id[match(match_id(rownames(txi_tx$counts)), tx2gene$tx_id)],
    stringsAsFactors = FALSE
  )
  unmatched <- sum(is.na(map$GENEID))
  if (unmatched > 0) {
    message(unmatched, " transcripts have no gene in the GTF and are left out of the gene matrix.")
  }
  map <- map[!is.na(map$GENEID), ]
  txi <- summarizeToGene(txi_tx, tx2gene = map)
  counts <- txi$counts
  ids <- rownames(counts)
  gene_name <- tx2gene$gene_name[match(ids, tx2gene$gene_id)]
  gene_name[is.na(gene_name)] <- ids[is.na(gene_name)]
  result <- data.frame(gene_id = ids, gene_name = gene_name,
                       round(counts, 2), check.names = FALSE, stringsAsFactors = FALSE)
}

colnames(result)[(ncol(result) - length(samples) + 1):ncol(result)] <- samples
write.csv(result, out_file, row.names = FALSE, quote = FALSE)

message("Wrote ", nrow(result), " ", level, "s x ", length(samples), " samples to ", out_file)
