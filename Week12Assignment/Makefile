# RNA-Seq Analysis with the HiSat2 aligner and salmon

# The location for the data
DATA_URL=http://data.biostarhandbook.com/data/rnaseq-tutorial-2026.tar.gz

# The reference genome file
FASTA=fasta/chr22.genome.fa

# The index file sentinel
FASTA_IDX = ${FASTA}.1.ht2

# The annotation file
GTF=gtf/chr22.gtf

# The transcript sequences (for salmon)
TX_FASTA = fasta/chr22.transcripts.fa

# The salmon index
SALMON_IDX = idx/salmon

# The sample name
SAMPLE = HBR_1

# The path to the read file
R1=fastq/${SAMPLE}_R1.fq

# Output alignment file
BAM = bam/${SAMPLE}.bam

# Output coverage file
BW  = bw/${SAMPLE}.bw

# Count files as text
COUNT = counts/${SAMPLE}.txt

# Salmon output file
QUANT = counts/${SAMPLE}/quant.sf

# The design file
DESIGN = design.csv

# Current directory
DIR = $(shell pwd)

# Netcat command to send commands to IGV
NC = nc localhost 60151

# Run two jobs at a time since the alignment is already multithreaded with 4 threads, thus using 2x4=8 cores
PARALLEL = parallel --eta --colsep , --header : --jobs 2 --lb

# --- All definitions above this line. All code below this line ---

# First target is the help.
help:
	@echo "# "
	@echo "# SAMPLE=${SAMPLE}"
	@echo "# FASTA=${FASTA}"
	@echo "# R1=${R1}"
	@echo "# BAM=${BAM}"
	@echo "# BW=${BW}"
	@echo "# COUNT=${COUNT}"
	@echo "# QUANT=${QUANT}"
	@echo "# "
	@echo "# make data"
	@echo "# make index"
	@echo "# make align"
	@echo "# make count"
	@echo "# make quant"
	@echo "# "
	@echo "# make batch"
	@echo "# make salmon_batch"
	@echo "# make matrix"
	@echo "# "

# Download and unpack the data
${FASTA} ${GTF} ${R1} &:
	curl ${DATA_URL} | tar xzvf -

data: ${FASTA} ${GTF} ${R1}
	ls -lh ${FASTA} ${GTF} ${R1}

# The index file
${FASTA_IDX}: ${FASTA}
	hisat2-build ${FASTA} ${FASTA}

# Index the genome.
index: ${FASTA_IDX}
	ls -lh ${FASTA_IDX}

# The rules to generate the BAM file
${BAM}: ${FASTA_IDX} ${R1}
	mkdir -p $(dir ${BAM})
	hisat2 --threads 4 --sensitive -x ${FASTA} -U ${R1} | \
		samtools sort --write-index -o ${BAM}

# The rules to generate the bigwig file
${BW}: ${BAM}
	mkdir -p $(dir ${BW})
	bamCoverage --binSize 1 -b ${BAM} -o ${BW}

align: ${BAM} ${BW}
	ls -lh ${BAM}
	ls -lh ${BW}

${COUNT}: ${BW}
	mkdir -p $(dir ${COUNT})
	featureCounts -a ${GTF} -s 2 -o ${COUNT} ${BAM}

counts: ${COUNT}
	ls -lh ${COUNT}

all: counts

# Extract the transcript sequences from the genome.
${TX_FASTA}: ${FASTA} ${GTF}
	gffread -w ${TX_FASTA} -g ${FASTA} ${GTF}

# Build the salmon index.
salmon_index: ${TX_FASTA}
	salmon index -t ${TX_FASTA} -i ${SALMON_IDX}

# Run salmon for one sample.
${QUANT}: ${R1}
	salmon quant -i ${SALMON_IDX} -l A -r ${R1} -p 4 -o counts/${SAMPLE}

quant: ${QUANT}
	ls -lh ${QUANT}

# Visualize with IGV
igv:
	echo "new" | ${NC}
	echo "genome ${DIR}/$(FASTA)" | ${NC}
	echo "load ${DIR}/$(GTF)" | ${NC}
	# Loads up the coverage files for each sample.
	cat $(DESIGN) | $(PARALLEL) 'echo "load ${DIR}/bw/{sample}.bw" | ${NC}'

# Generate all counts for every sample
batch:
	# Ensure that the index is built before running the alignments.
	make index

	# Run the alignments for each sample.
	cat $(DESIGN) | $(PARALLEL) make SAMPLE={sample} all

# Run salmon for every sample
salmon_batch:
	# Build the salmon index once, before running salmon.
	make salmon_index

	# Run salmon for each sample.
	cat $(DESIGN) | $(PARALLEL) make SAMPLE={sample} quant

# Combine the counts into count matrices
matrix:
	Rscript src/combine_gene_counts.R
	Rscript src/combine_transcript_counts.R transcript
	Rscript src/combine_transcript_counts.R gene

.PHONY: all help download index align bam bw counts salmon_index quant salmon_batch matrix

# Additional Makefile settings
SHELL := bash
.DELETE_ON_ERROR:
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
MAKEFLAGS += --warn-undefined-variables --no-print-directory
