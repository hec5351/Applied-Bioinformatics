# URL of the reference genome
GCF_URL = https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/040/556/925/GCF_040556925.1_ASM4055692v1/GCF_040556925.1_ASM4055692v1_genomic.fna.gz

# Name of the reference genome
GENOME_NAME = Mycoplasma_genitalium

# Genome fasta file
GENOME_FASTA = fasta/$(GENOME_NAME).fasta

# SRR accession number
SRR = SRR39974648

# Number of reads to download
N = 28970

# Fastq files
FASTQ_1 = fastq/$(SRR)_1.fastq
FASTQ_2 = fastq/$(SRR)_2.fastq

# Sample name
SAMPLE_NAME = Mycoplasma_genitalium

# BAM file derived from the sample name
BAM = bam/$(SAMPLE_NAME).bam

# BWA index sentinel
INDEX = $(GENOME_FASTA).bwt


# --- All definitions above this line. All code below this line ---

usage:
	@echo "# Read the source code"

# Run all steps.
all: genome fastq index align

# Download the genome.
genome: $(GENOME_FASTA)

$(GENOME_FASTA):
	mkdir -p $(dir $@)
	curl -fsSL $(GCF_URL) | gunzip > $@
	seqkit stats $@

# Download the fastq files.
fastq: $(FASTQ_1) $(FASTQ_2)

$(FASTQ_1) $(FASTQ_2):
	mkdir -p $(dir $@)
	fastq-dump -X $(N) --split-files -O $(dir $@) $(SRR)
	seqkit stats $(FASTQ_1) $(FASTQ_2)

# Index the genome.
index: $(INDEX)

$(INDEX): $(GENOME_FASTA)
	bwa index $<

# Align the fastq files to the genome.
align: $(BAM)

$(BAM): $(INDEX) $(FASTQ_1) $(FASTQ_2)
	mkdir -p $(dir $@)
	bwa mem $(GENOME_FASTA) $(FASTQ_1) $(FASTQ_2) | samtools sort -o $@
	samtools index $@
	samtools flagstat $@

# Remove some of the generated files.
clean:
	rm -rf $(FASTQ_1) $(FASTQ_2) $(BAM) $(BAM).bai

.PHONY: usage all genome fastq index align clean