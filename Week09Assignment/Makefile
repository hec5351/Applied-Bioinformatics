# Reference genome and annotation
GCF_URL = https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/040/556/925/GCF_040556925.1_ASM4055692v1/GCF_040556925.1_ASM4055692v1_genomic.fna.gz
GFF_URL = https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/040/556/925/GCF_040556925.1_ASM4055692v1/GCF_040556925.1_ASM4055692v1_genomic.gff.gz
GENOME_NAME = Mycoplasma_genitalium
GENOME_FASTA = fasta/$(GENOME_NAME).fasta
GFF = gff/$(GENOME_NAME).gff
INDEX = $(GENOME_FASTA).bwt

# Sample parameters. The batch target overrides them for every row of the design file.
# Running "make all" alone processes just this one sample.
RUN = SRR39974648
SAMPLE = MG122
GROUP = NA
CONDITION = NA

# Read pairs to download per sample. The project is amplicon sequencing, so reads pile up
# on a few kb of the genome and a small N already gives very high depth there.
N = 20000

FASTQ_1 = fastq/$(RUN)_1.fastq
FASTQ_2 = fastq/$(RUN)_2.fastq
BAM = bam/$(SAMPLE).bam
VCF = vcf/$(SAMPLE).vcf.gz

# The name of the design file
DESIGN = design.csv

# The parallel command to run the workflow with
PARALLEL = parallel --colsep , --header : --eta --lb -j 4

# Samples listed in the design file and the per-sample VCF files
SAMPLES = $(shell tail -n +2 $(DESIGN) 2>/dev/null | cut -d, -f2)
VCFS = $(patsubst %,vcf/%.vcf.gz,$(SAMPLES))
MERGED = vcf/merged.vcf.gz

# bcftools parameters (haploid bacterium)
ANN = -d 100 --annotate 'INFO/AD,FORMAT/DP,FORMAT/AD,FORMAT/ADF,FORMAT/ADR,FORMAT/SP'
CALL = --ploidy 1 --annotate 'FORMAT/GQ'

# IGV
DIR = $(shell pwd)
NC = nc localhost 60151

# --- All definitions above this line. All code below this line ---

usage:
	@echo "make all                      # one sample (RUN, SAMPLE)"
	@echo "make batch merge report       # every sample in $(DESIGN)"

# ---- Steps for ONE sample ----

all: $(VCF)

$(GENOME_FASTA):
	mkdir -p $(dir $@)
	curl -fsSL $(GCF_URL) | gunzip > $@

$(GFF):
	mkdir -p $(dir $@)
	curl -fsSL $(GFF_URL) | gunzip -c > $@

$(INDEX): $(GENOME_FASTA)
	bwa index $<
	samtools faidx $<

$(FASTQ_1) $(FASTQ_2):
	mkdir -p $(dir $@)
	fastq-dump -X $(N) --split-files -O $(dir $@) $(RUN)

# The read group puts the sample name into the VCF.
$(BAM): $(INDEX) $(FASTQ_1) $(FASTQ_2)
	mkdir -p $(dir $@)
	bwa mem -R '@RG\tID:$(SAMPLE)\tSM:$(SAMPLE)' $(GENOME_FASTA) $(FASTQ_1) $(FASTQ_2) | samtools sort -o $@
	samtools index $@

$(VCF): $(BAM)
	mkdir -p $(dir $@)
	bcftools mpileup ${ANN} -O u -f $(GENOME_FASTA) $(BAM) | \
		bcftools call $(CALL) -mv -O u | \
		bcftools norm -f $(GENOME_FASTA) -d all -O u | \
		bcftools sort --write-index -O z -o $@

# ---- Steps for ALL samples ----

# Batch processing using the design file. The genome and its index are built first,
# so that the parallel jobs do not try to build them at the same time.
batch: $(INDEX) $(GFF) $(DESIGN)
	cat $(DESIGN) | $(PARALLEL) make \
		RUN={Run} \
		SAMPLE={Sample} \
		GROUP={Group} \
		CONDITION={Condition} \
		all

# Merge the per-sample VCF files into a single VCF file.
merge: $(MERGED)

$(MERGED): $(VCFS)
	bcftools merge --write-index -O z -o $@ $(VCFS)

# Mean depth over the positions that have reads (amplicon data covers only a small part of the genome).
export DEPTH_AWK = {n++; s+=$$3} END{ if (n) printf "%d\t%.0f\t", n, s/n; else printf "0\t0\t" }

# One line per sample: group, condition, covered bases, mean depth at covered bases, variants.
report: $(VCFS)
	@printf "Sample\tGroup\tCondition\tCoveredBases\tMeanDepthCovered\tVariants\n"
	@cat $(DESIGN) | parallel --colsep , --header : -k -j 4 \
		'printf "{Sample}\t{Group}\t{Condition}\t"; samtools depth bam/{Sample}.bam | awk "$$DEPTH_AWK"; bcftools view -H vcf/{Sample}.vcf.gz | wc -l'

# Visualize in IGV (IGV must be running with the port enabled).
igv: $(MERGED) $(GFF)
	echo "new" | ${NC}
	echo "genome ${DIR}/$(GENOME_FASTA)" | ${NC}
	$(foreach s,$(SAMPLES),echo "load ${DIR}/bam/$(s).bam" | ${NC};)
	echo "load ${DIR}/$(MERGED)" | ${NC}
	echo "load ${DIR}/$(GFF)" | ${NC}

clean:
	rm -rf fastq bam vcf

.PHONY: usage all batch merge report igv clean
