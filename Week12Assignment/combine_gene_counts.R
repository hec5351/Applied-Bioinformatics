#!/usr/bin/env Rscript
#
# combine_gene_counts.R
#
# Combine the per-sample featureCounts files (counts/<sample>.txt, made by
# `make batch`) into one gene-level count matrix. There is one column per
# sample, named as in design.csv, and each row has a gene ID and gene name.
#
# Usage (all arguments optional; defaults match the Makefile):
#   Rscript src/combine_gene_counts.R [design.csv] [counts_dir] [gtf] [output.csv]
#
# Defaults:
#   Rscript src/combine_gene_counts.R design.csv counts gtf/chr22.gtf res/gene_counts.csv

setwd("/Users/haleyecurtis/BMMB852/Week12")

args <- commandArgs(trailingOnly = TRUE)
defaults <- c("design.csv", "counts", "gtf/chr22.gtf", "res/gene_counts.csv")
if (length(args) > 4) {
  stop("Usage: Rscript combine_gene_counts.R [design.csv] [counts_dir] [gtf] [output.csv]")
}
args <- c(args, defaults[(length(args) + 1):4])[1:4]
design_file <- args[1]
counts_dir  <- args[2]
gtf_file    <- args[3]
out_file    <- args[4]

# ---- Sample names from the design file --------------------------------------
design  <- read.csv(design_file, stringsAsFactors = FALSE)
samples <- design$sample

# ---- Read each featureCounts file -------------------------------------------
# Each file has a comment line, then: Geneid Chr Start End Strand Length <BAM>
read_fc <- function(sample) {
  path <- file.path(counts_dir, paste0(sample, ".txt"))
  if (!file.exists(path)) stop("Missing featureCounts file: ", path)
  fc <- read.delim(path, comment.char = "#", check.names = FALSE, stringsAsFactors = FALSE)
  out <- fc[, c(1, 7)]
  names(out) <- c("gene_id", sample)
  out
}
tables <- lapply(samples, read_fc)

# All files come from the same GTF, so the genes should be in the same order.
gene_ids <- tables[[1]]$gene_id
for (t in tables) {
  if (!identical(t$gene_id, gene_ids)) stop("featureCounts files do not list the same genes.")
}
counts <- do.call(cbind, lapply(tables, function(t) t[, 2, drop = FALSE]))

# ---- Gene names from the GTF ------------------------------------------------
get_attr <- function(a, key) {
  out <- rep(NA_character_, length(a))
  has <- grepl(paste0(key, ' "'), a)
  out[has] <- sub(paste0(".*", key, ' "([^"]+)".*'), "\\1", a[has])
  out
}
lines <- readLines(gtf_file)
lines <- lines[!startsWith(lines, "#")]
attrs <- vapply(strsplit(lines, "\t", fixed = TRUE),
                function(x) if (length(x) >= 9) x[9] else NA_character_, "")
attrs <- attrs[!is.na(attrs)]
genes <- data.frame(gene_id   = get_attr(attrs, "gene_id"),
                    gene_name = get_attr(attrs, "gene_name"),
                    stringsAsFactors = FALSE)
genes <- genes[!is.na(genes$gene_id) & !duplicated(genes$gene_id), ]

gene_name <- genes$gene_name[match(gene_ids, genes$gene_id)]
gene_name[is.na(gene_name)] <- gene_ids[is.na(gene_name)]  # fall back to the ID

# ---- Write the matrix --------------------------------------------------------
result <- data.frame(gene_id = gene_ids, gene_name = gene_name, counts,
                     check.names = FALSE, stringsAsFactors = FALSE)
dir.create(dirname(out_file), showWarnings = FALSE, recursive = TRUE)
write.csv(result, out_file, row.names = FALSE, quote = FALSE)

message("Wrote ", nrow(result), " genes x ", length(samples), " samples to ", out_file)
