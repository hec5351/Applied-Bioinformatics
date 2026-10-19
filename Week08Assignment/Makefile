# Reference genome and annotation
GCF_URL = https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/040/556/925/GCF_040556925.1_ASM4055692v1/GCF_040556925.1_ASM4055692v1_genomic.fna.gz
GFF_URL = https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/040/556/925/GCF_040556925.1_ASM4055692v1/GCF_040556925.1_ASM4055692v1_genomic.gff.gz
GENOME_NAME = Mycoplasma_genitalium
GENOME_FASTA = fasta/$(GENOME_NAME).fasta
GFF = gff/$(GENOME_NAME).gff

# Samples as SAMPLE_NAME:SRR (the first is from the previous assignment)
SAMPLES = EM100:SRR39974648 M6282:ERR486831 M2321:ERR486844 M6320:ERR486850
SAMPLE_NAMES = $(foreach s,$(SAMPLES),$(firstword $(subst :, ,$(s))))

# Single-sample defaults (make samples overrides them for each sample)
SRR = SRR39974648
SAMPLE_NAME = EM100

# Number of read pairs to download per sample
N = 60000

FASTQ_1 = fastq/$(SRR)_1.fastq
FASTQ_2 = fastq/$(SRR)_2.fastq
BAM = bam/$(SAMPLE_NAME).bam
VCF = vcf/$(SAMPLE_NAME).vcf.gz
INDEX = $(GENOME_FASTA).bwt

BAMS = $(patsubst %,bam/%.bam,$(SAMPLE_NAMES))
VCFS = $(patsubst %,vcf/%.vcf.gz,$(SAMPLE_NAMES))
MERGED = vcf/merged.vcf.gz
JOINT = vcf/joint.vcf.gz

# bcftools parameters (haploid bacterium)
ANN = -d 100 --annotate 'INFO/AD,FORMAT/DP,FORMAT/AD,FORMAT/ADF,FORMAT/ADR,FORMAT/SP'
CALL = --ploidy 1 --annotate 'FORMAT/GQ'

# IGV
DIR = $(shell pwd)
NC = nc localhost 60151

# --- All definitions above this line. All code below this line ---

usage:
	@echo "make genome gff samples merge joint cds igv   (or: make all)"

all: genome gff samples merge joint

genome: $(GENOME_FASTA)

$(GENOME_FASTA):
	mkdir -p $(dir $@)
	curl -fsSL $(GCF_URL) | gunzip > $@

gff: $(GFF)

$(GFF):
	mkdir -p $(dir $@)
	curl -fsSL $(GFF_URL) | gunzip -c > $@

$(FASTQ_1) $(FASTQ_2):
	mkdir -p $(dir $@)
	fastq-dump -X $(N) --split-files -O $(dir $@) $(SRR)

$(INDEX): $(GENOME_FASTA)
	bwa index $<
	samtools faidx $<

# The read group puts the sample name into the VCF.
$(BAM): $(INDEX) $(FASTQ_1) $(FASTQ_2)
	mkdir -p $(dir $@)
	bwa mem -R '@RG\tID:$(SAMPLE_NAME)\tSM:$(SAMPLE_NAME)' $(GENOME_FASTA) $(FASTQ_1) $(FASTQ_2) | samtools sort -o $@
	samtools index $@

$(VCF): $(BAM)
	mkdir -p $(dir $@)
	bcftools mpileup ${ANN} -O u -f $(GENOME_FASTA) $(BAM) | \
		bcftools call $(CALL) -mv -O u | \
		bcftools norm -f $(GENOME_FASTA) -d all -O u | \
		bcftools sort --write-index -O z -o $@

# Run the pipeline for one sample (SRR and SAMPLE_NAME), or for every sample in SAMPLES.
sample: $(VCF)

samples: genome
	for s in $(SAMPLES); do \
		$(MAKE) sample SAMPLE_NAME=$${s%%:*} SRR=$${s##*:} || exit 1; \
	done

# Merge the per-sample VCF files.
merge: $(MERGED)

$(MERGED): $(VCFS)
	bcftools merge --write-index -O z -o $@ $(VCFS)

# Call all BAM files simultaneously.
joint: $(JOINT)

$(JOINT): $(BAMS)
	bcftools mpileup ${ANN} -O u -f $(GENOME_FASTA) $(BAMS) | \
		bcftools call $(CALL) -mv -O u | \
		bcftools norm -f $(GENOME_FASTA) -d all -O u | \
		bcftools sort --write-index -O z -o $@

# Variants in coding sequences. Columns: chrom, pos, ref, alt, one genotype per
# sample, then the CDS start, end, strand and attributes.
cds: $(JOINT) $(GFF)
	bcftools query -f '%CHROM\t%POS\t%REF\t%ALT[\t%GT]\n' $(JOINT) | \
		awk -F'\t' -v OFS='\t' 'NR==FNR{ if($$3=="CDS"){n++;c[n]=$$1;s[n]=$$4;e[n]=$$5;st[n]=$$7;a[n]=$$9} next } { for(i=1;i<=n;i++) if($$1==c[i] && $$2>=s[i] && $$2<=e[i]) print $$0,s[i],e[i],st[i],a[i] }' $(GFF) -

# Visualize in IGV (IGV must be running with the port enabled).
igv: $(BAMS) $(MERGED) $(JOINT) $(GFF)
	echo "new" | ${NC}
	echo "genome ${DIR}/$(GENOME_FASTA)" | ${NC}
	for b in $(BAMS); do echo "load ${DIR}/$$b" | ${NC}; done
	echo "load ${DIR}/$(MERGED)" | ${NC}
	echo "load ${DIR}/$(JOINT)" | ${NC}
	echo "load ${DIR}/$(GFF)" | ${NC}

clean:
	rm -rf fastq bam vcf

.PHONY: usage all genome gff sample samples merge joint cds igv clean
