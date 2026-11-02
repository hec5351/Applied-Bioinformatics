# Reference genome and annotation: E. coli K-12 MG1655
GCF_URL = https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/005/845/GCF_000005845.2_ASM584v2/GCF_000005845.2_ASM584v2_genomic.fna.gz
GFF_URL = https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/005/845/GCF_000005845.2_ASM584v2/GCF_000005845.2_ASM584v2_genomic.gff.gz
GENOME_NAME = Ecoli_MG1655
GENOME_FASTA = fasta/$(GENOME_NAME).fasta
GFF = gff/$(GENOME_NAME).gff
INDEX = $(GENOME_FASTA).bwt

# Genome size in bp, used by MACS3
GENOME_SIZE = 4641652

# Sample parameters. The batch and peaks targets override them for every row of the design file.
RUN = SRR1285991
SAMPLE = SRR1285991
GROUP = ip
CONDITION = rep1

# Reads to download per sample (single-end, 51 bp: 3,000,000 reads is about 33x coverage)
N = 3000000

FASTQ = fastq/$(RUN).fastq
BAM = bam/$(SAMPLE).bam
PEAKS = peaks/$(SAMPLE)_peaks.narrowPeak

# The name of the design file
DESIGN = design.csv

# The parallel command to run the workflow with
PARALLEL = parallel --colsep , --header : --eta --lb -j 4

# Sample names, and the input (background) samples, taken from the design file with parallel
SAMPLES = $(shell cat $(DESIGN) 2>/dev/null | parallel --colsep , --header : -k 'echo {Sample}')
INPUT_BAMS = $(shell cat $(DESIGN) 2>/dev/null | parallel --colsep , --header : -k 'test "{Group}" = input && echo bam/{Sample}.bam')
BACKGROUND = bam/background.bam

# Replicates to compare (two IP samples)
REP1 = SRR1285991
REP2 = SRR1285993

# IGV
DIR = $(shell pwd)
NC = nc localhost 60151

# --- All definitions above this line. All code below this line ---

usage:
	@echo "make batch        # align every sample in $(DESIGN)"
	@echo "make background   # merge the input samples into one background BAM"
	@echo "make peaks        # call peaks for every IP sample against the background"
	@echo "make report       # number of peaks per sample"
	@echo "make compare      # overlap of the peaks of $(REP1) and $(REP2)"
	@echo "make igv          # load tracks in IGV"

# ---- Steps for ONE sample ----

all: $(BAM)

$(GENOME_FASTA):
	mkdir -p $(dir $@)
	curl -fsSL $(GCF_URL) | gunzip > $@

$(GFF):
	mkdir -p $(dir $@)
	curl -fsSL $(GFF_URL) | gunzip -c > $@

$(INDEX): $(GENOME_FASTA)
	bwa index $<
	samtools faidx $<

$(FASTQ):
	mkdir -p $(dir $@)
	fastq-dump -X $(N) -O $(dir $@) $(RUN)

# Keep mapped reads with a unique best hit (MAPQ >= 1), sorted and indexed.
$(BAM): $(INDEX) $(FASTQ)
	mkdir -p $(dir $@)
	bwa mem -R '@RG\tID:$(SAMPLE)\tSM:$(SAMPLE)' $(GENOME_FASTA) $(FASTQ) | samtools view -b -F 4 -q 1 | samtools sort -o $@
	samtools index $@

# Call peaks for one IP sample against the background.
peak: $(PEAKS)

$(PEAKS): $(BAM) $(BACKGROUND)
	mkdir -p $(dir $@)
	macs3 callpeak -t $(BAM) -c $(BACKGROUND) -f BAM -g $(GENOME_SIZE) -n $(SAMPLE) --outdir $(dir $@) -q 0.01 --nomodel --extsize 200

# ---- Steps for ALL samples ----

# Align every sample in the design file. The genome and index are built first,
# so that the parallel jobs do not try to build them at the same time.
batch: $(INDEX) $(GFF) $(DESIGN)
	cat $(DESIGN) | $(PARALLEL) make \
		RUN={Run} \
		SAMPLE={Sample} \
		GROUP={Group} \
		CONDITION={Condition} \
		all

# The background: all input samples merged into one BAM file.
background: $(BACKGROUND)

$(BACKGROUND): $(INPUT_BAMS)
	samtools merge -f $@ $(INPUT_BAMS)
	samtools index $@

# Peaks for every IP sample (the input samples are skipped).
peaks: $(BACKGROUND)
	cat $(DESIGN) | $(PARALLEL) 'test "{Group}" = ip && make RUN={Run} SAMPLE={Sample} GROUP={Group} CONDITION={Condition} peak || true'

# Number of peaks per IP sample.
report:
	@printf "Sample\tPeaks\n"
	@cat $(DESIGN) | parallel --colsep , --header : -k 'test "{Group}" = ip && printf "{Sample}\t" && wc -l < peaks/{Sample}_peaks.narrowPeak || true'

# Peaks of REP1 that overlap a peak of REP2, and peaks found in only one replicate.
compare:
	@printf "$(REP1) peaks: "; wc -l < peaks/$(REP1)_peaks.narrowPeak
	@printf "$(REP2) peaks: "; wc -l < peaks/$(REP2)_peaks.narrowPeak
	@printf "shared (overlap): "; bedtools intersect -a peaks/$(REP1)_peaks.narrowPeak -b peaks/$(REP2)_peaks.narrowPeak -u | wc -l
	@printf "only in $(REP1): "; bedtools intersect -a peaks/$(REP1)_peaks.narrowPeak -b peaks/$(REP2)_peaks.narrowPeak -v | wc -l
	@printf "only in $(REP2): "; bedtools intersect -a peaks/$(REP2)_peaks.narrowPeak -b peaks/$(REP1)_peaks.narrowPeak -v | wc -l

# Visualize in IGV (IGV must be running with the port enabled).
igv: $(GFF)
	echo "new" | ${NC}
	echo "genome ${DIR}/$(GENOME_FASTA)" | ${NC}
	$(foreach s,$(SAMPLES),echo "load ${DIR}/bam/$(s).bam" | ${NC};)
	$(foreach s,$(SAMPLES),test -f peaks/$(s)_peaks.narrowPeak && echo "load ${DIR}/peaks/$(s)_peaks.narrowPeak" | ${NC}; true;)
	echo "load ${DIR}/$(GFF)" | ${NC}

clean:
	rm -rf fastq bam peaks

.PHONY: usage all peak batch background peaks report compare igv clean
