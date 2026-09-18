
#Run everything with "pixie run make all"

SRR = SRR098291
SAMPLE_NAME = Apis_florea
N = 100000

#Step 1: Download the first 100000 reads and rename to a descriptive name:
#This run has two files: _1 is a 4bp technical/barcode read (not usable data),
#_2 is the real biological read. We only use _2 from here on.
download:
	mkdir -p fastq
	fastq-dump -X $(N) --split-files --outdir fastq $(SRR)
	mv fastq/$(SRR)_2.fastq fastq/$(SAMPLE_NAME).fastq


#Step 2: QC on raw reads and generate report:
fastqc_raw:
	mkdir -p fastqc_raw
	fastqc fastq/$(SAMPLE_NAME).fastq -o fastqc_raw
	multiqc fastqc_raw -o fastqc_raw

#Step 3: Trim reads using fastp:
trimmed_fastq:
	mkdir -p trimmed_fastq
	fastp \
		-i fastq/$(SAMPLE_NAME).fastq \
		-o trimmed_fastq/$(SAMPLE_NAME).trimmed.fastq


#Step 4: QC on trimmed reads and generate report:
fastqc_trimmed:
	mkdir -p fastqc_trimmed
	fastqc trimmed_fastq/$(SAMPLE_NAME).trimmed.fastq -o fastqc_trimmed
	multiqc fastqc_trimmed -o fastqc_trimmed


#Step 5: run everything in order
all: download fastqc_raw trimmed_fastq fastqc_trimmed


.PHONY: download fastqc_raw trimmed_fastq fastqc_trimmed all
