# Generate a count matrix

This assignment builds count matrices for the HBR and UHR samples listed in `design.csv`:

1. **Gene-level counts from featureCounts.** The HISAT2 alignments are counted per gene (`src/combine_gene_counts.R`).
2. **Transcript-level counts from salmon.** These are combined into a transcript matrix, then summed per gene into a second gene matrix (`src/combine_transcript_counts.R`).

Every matrix has one column per sample, named as in `design.csv`, and every row has a gene name taken from `gtf/chr22.gtf`.

## Repository layout

Run every command from the repository's root folder, not from inside `src/`.

```
.
├── Makefile
├── design.csv
├── README.md
└── src/
    ├── combine_gene_counts.R
    └── combine_transcript_counts.R
```

The Makefile creates the `fasta/`, `gtf/`, `fastq/`, `bam/`, `bw/`, `counts/`, `idx/` and `res/` folders as it runs.

## Software setup

The pipeline uses two micromamba environments:

- **`rnaseq`** holds the command-line tools.
- **`stats`** holds R and tximport.

Keeping R in its own environment avoids library conflicts with the command-line tools.

```bash
# Command-line tools
micromamba create -n rnaseq -c conda-forge -c bioconda \
    hisat2 samtools deeptools subread salmon gffread parallel openssl

# R and tximport
micromamba create -n stats -c conda-forge -c bioconda \
    r-base bioconductor-tximport
```

On an Apple Silicon (M1/M2/M3) Mac, some bioconda packages, such as hisat2, are only built for Intel. If a create command fails with "nothing provides" or "package not found", put `CONDA_SUBDIR=osx-64` in front of it. For example:

```bash
CONDA_SUBDIR=osx-64 micromamba create -n rnaseq -c conda-forge -c bioconda \
    hisat2 samtools deeptools subread salmon gffread parallel openssl
```

Check that the tools are found before running anything:

```bash
micromamba activate rnaseq
which hisat2-build samtools bamCoverage featureCounts salmon gffread parallel
samtools --version     # should print a version, not a "Library not loaded" error

micromamba activate stats
Rscript -e 'library(tximport); cat("tximport OK\n")'
```

`openssl` is in the `rnaseq` list because samtools crashed with `Library not loaded: @rpath/libcrypto.3.dylib` when OpenSSL was missing from the environment.

## How to run

### 1. Align and count with featureCounts (`rnaseq` environment)

```bash
micromamba activate rnaseq

# Download the reference, annotation and reads
make data

# Build the HISAT2 index, then align, make coverage files, and count every sample
make batch
```

This makes `bam/<sample>.bam`, `bw/<sample>.bw` and `counts/<sample>.txt` for every sample in `design.csv`.

### 2. View the coverage in IGV (`rnaseq` environment)

Open IGV first, then run:

```bash
make igv
```

This loads the genome, the GTF, and the coverage file for every sample.

### 3. Quantify transcripts with salmon (`rnaseq` environment)

```bash
make salmon_batch
```

This builds the salmon index once, then runs salmon on every sample, making `counts/<sample>/quant.sf`. Check that all six files exist:

```bash
ls counts/*/quant.sf
```

If salmon was interrupted or failed before, delete its output and start again:

```bash
rm -rf idx/salmon counts/*/
make salmon_batch
```

The trailing slash in `counts/*/` matches only the salmon folders. The featureCounts files (`counts/<sample>.txt`) are kept.

### 4. Build the count matrices (`stats` environment)

```bash
micromamba activate stats

# Gene counts from featureCounts       -> res/gene_counts.csv
Rscript src/combine_gene_counts.R

# Transcript counts from salmon        -> res/transcript_counts.csv
Rscript src/combine_transcript_counts.R transcript

# Salmon counts summed per gene        -> res/gene_counts_salmon.csv
Rscript src/combine_transcript_counts.R gene
```

`make matrix` runs the same three commands. Run it from the `stats` environment too, because the R scripts need tximport.

Check the results:

```bash
ls res/
```

### Optional: different file locations

The scripts' default paths match the Makefile, so the commands above need no extra arguments. To use other locations, give the paths in this order:

```bash
# combine_gene_counts.R:        design file, counts folder, GTF, output file
Rscript src/combine_gene_counts.R design.csv counts gtf/chr22.gtf res/gene_counts.csv

# combine_transcript_counts.R:  level (transcript or gene), design file, counts folder, GTF, output file
Rscript src/combine_transcript_counts.R gene design.csv counts gtf/chr22.gtf res/gene_counts_salmon.csv
```

## Does the count matrix support the IGV results?

In the [Week 11 assignment](https://github.com/hec5351/Applied-Bioinformatics/tree/main/Week11Assignmnet), IGV showed three patterns:

- **APOL4** was not expressed in any sample.
- **CBX6** was strongly expressed in all six samples.
- **IGLL5** was expressed only in UHR and was effectively absent from HBR.

To check these genes in both gene-level matrices, run this in the `stats` environment:

```bash
Rscript -e '
genes <- c("APOL4", "CBX6", "IGLL5")
for (f in c("res/gene_counts.csv", "res/gene_counts_salmon.csv")) {
  x <- read.csv(f)
  cat("\n", f, "\n")
  print(x[x$gene_name %in% genes, -1], row.names = FALSE)
}
'
```

Average counts per group (mean of the three replicates):

| Gene | IGV (Week 11) | featureCounts (HBR / UHR) | salmon (HBR / UHR) | Agrees? |
|---|---|---|---|---|
| APOL4 | Not expressed | 7.7 / 5.3 | 8.0 / 6.7 | Mostly |
| CBX6 | High in all samples | 815 / 299 | 815 / 297 | Yes |
| IGLL5 | UHR only | 0 / 0.3 | 0 / 0 | No |

The count matrices support two of the three IGV observations, and the two methods (featureCounts and salmon) agree closely with each other for all three genes.

- **CBX6** has hundreds of reads in every sample, which confirms that it is strongly expressed everywhere. The matrices also show something that was hard to see in IGV: CBX6 is about 2.7 times higher in HBR than in UHR.
- **APOL4** has only 4 to 10 reads per sample. That is very low compared with CBX6, so it is effectively not expressed, which matches IGV. The handful of reads were too few to stand out in the coverage track.
- **IGLL5** does not match. IGV showed a large UHR-only peak, but both methods give it essentially zero reads in every sample. Because featureCounts and salmon agree, the problem is probably not with either counting method. The most likely explanation is that the UHR peak I saw in IGV was over a neighboring gene, or over a part of the region that is not in the IGLL5 exons, rather than over IGLL5 itself. Counting tools only assign reads that fall on a gene's annotated exons, while IGV shows every read in the window.

This shows why a count matrix is a useful check on visual inspection: it ties each read to a specific annotated gene, while a coverage track can be misread when genes are close together.

# My Experience with AI programming

Overall, the AI assistant was extremely helpful. I like the way it formatted the sample Makefile, and I plan to implement its features in my future assignments. I had trouble getting the AI assistant to understand my instructions. I had to prompt it several times and went through several iterations before the results were correct.
