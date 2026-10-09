# URL of the reference genome
GCF_URL = https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/040/556/925/GCF_040556925.1_ASM4055692v1/GCF_040556925.1_ASM4055692v1_genomic.fna.gz

# Name of the reference genome
GENOME_NAME = Mycoplasma_genitalium

# Genome fasta file
GENOME_FASTA = fasta/$(GENOME_NAME).fasta

# SRR accession number
SRR = SRR39974648

# Number of reads to download
N = 60000

# Fastq files
FASTQ_1 = fastq/$(SRR)_1.fastq
FASTQ_2 = fastq/$(SRR)_2.fastq

# Sample name
SAMPLE_NAME = Mycoplasma_genitalium

# BAM file derived from the sample name
BAM = bam/$(SAMPLE_NAME).bam

# BWA index sentinel
INDEX = $(GENOME_FASTA).bwt

# Variant calling outputs
VCF = vcf/$(SAMPLE_NAME).vcf.gz
STATS = vcf/$(SAMPLE_NAME).stats.txt

# Annotation parameters for the mpileup command
ANN = -d 100 --annotate 'INFO/AD,FORMAT/DP,FORMAT/AD,FORMAT/ADF,FORMAT/ADR,FORMAT/SP'

# Call parameters (bacteria are haploid, so ploidy 1)
CALL = --ploidy 1 --annotate 'FORMAT/GQ'


# --- All definitions above this line. All code below this line ---

usage:
	@echo "# Read the source code"

# Run all steps.
all: genome fastq index align vcf coverage stats

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
	samtools faidx $<

# Align the fastq files to the genome.
align: $(BAM)

$(BAM): $(INDEX) $(FASTQ_1) $(FASTQ_2)
	mkdir -p $(dir $@)
	bwa mem $(GENOME_FASTA) $(FASTQ_1) $(FASTQ_2) | samtools sort -o $@
	samtools index $@
	samtools flagstat $@

# Call variants and create the VCF file.
vcf: $(VCF)

$(VCF): $(BAM)
	mkdir -p $(dir $@)
	bcftools mpileup $(ANN) -O u -f $(GENOME_FASTA) $(BAM) | \
		bcftools call $(CALL) -mv -O u | \
		bcftools norm -f $(GENOME_FASTA) -d all -O u | \
		bcftools sort -O z -o $@
	bcftools index -f $@

# Report the genome coverage (must be at least 10x).
coverage: $(BAM)
	samtools coverage $(BAM)
	samtools depth -a $(BAM) | awk '{s+=$$3; n++} END {printf "Mean depth: %.1fx\n", s/n}'

# Statistics report on the VCF file.
stats: $(VCF)
	bcftools stats $(VCF) > $(STATS)
	@echo "Total variants: $$(bcftools view -H $(VCF) | wc -l)"
	@echo "SNPs:           $$(bcftools view -H -v snps $(VCF) | wc -l)"
	@echo "Indels:         $$(bcftools view -H -v indels $(VCF) | wc -l)"
	@grep '^TSTV' $(STATS) | cut -f 2-5

# Remove some of the generated files.
clean:
	rm -rf $(FASTQ_1) $(FASTQ_2) $(BAM) $(BAM).bai $(VCF) $(VCF).csi $(STATS)

.PHONY: usage all genome fastq index align vcf coverage stats clean