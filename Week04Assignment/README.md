## Task
### Visit the SRA or ENA website and search for sequencing data deposited for the genome you chose in the previous assignment. Compile a short report describing how much data is available for your genome in the public scientific literature.   


The genome I chose in the previous assignment was _Apis florea_ (the little honey bee). On SRA, there are 70 results for this genome. 67 of them are from Illumina, 2 of them are from LS454, and 1 of them is from Oxford Nanopore. On ENA, there are 3 results for assembled genomes. There are 15 studies and 19 projects related to the _Apis florea_ genome. To compare the availability of the _Apis florea_ genome, I searched for _Apis mellifera_ (the European honey bee), which is a closely related organism used worldwide for honey production. On SRA, there are 14,374 results for the _Apis mellifera_ genome. On ENA, there are 889 assembled genomes, 36,153 experiments, and 27,622 runs for _Apis mellifera_. Therefore, _Apis florea_ is not well documented in the literature compared to other members of its genus. 

## Assess the experimental evidence for the genome
### Question 1: How "popular" is this genome? How many datasets are available?  


This genome is not very "popular." On SRA, there are 162 BioSample and 13 BioProject databases.   



### Question 2: What is the breakdown by sequencing strategy and platform (or some other attribute)?  


On SRA, there are 70 results for this genome. 67 of them are from Illumina, 2 of them are from LS454, and 1 of them is from Oxford Nanopore. On ENA, there are 3 results for assembled genomes. There are 15 studies and 19 projects related to the _Apis florea_ genome.  



### Question 3: What do you find interesting or surprising?  


I find it interesting that the _Apis florea_ genome is not very well studied, as _Apis mellifera_, one of its closest relatives, is one of the most studied insects.



## Download FASTQ files for an experiment
### The Makefile should download the first N reads from an SRR accession. Place the files in directories named after the data type.
# A note on my genome: This run has two files: _1 is a 4bp technical/barcode read (not usable data), _2 is the real biological read. I only use _2 for each step (except the download step), so anyone else running this would have to add _1 to each step (assuming they had 2 usable data files).


```bash
SRR: SRR098291
N = 100000
mkdir -p fastq
fastq-dump -X $(N) --split-files --outdir fastq $(SRR)
```  

### Run a QC visualization on the downloaded reads to generate a report.
```bash
mkdir -p fastqc_raw
fastqc fastq/$(SRR)_2.fastq -o fastqc_raw
multiqc fastqc_raw -o fastqc_raw
```  


### Apply a QC method to the reads to see whether it makes a visual difference (trim reads with fastp).  


```bash
mkdir -p trimmed_fastq
fastp \
-i fastq/$(SRR)_2.fastq \
-o trimmed_fastq/$(SRR).trimmed.fastq
```

### Run a QC visualization on the trimmed reads to generate a report.
```
mkdir -p fastqc_trimmed
fastqc trimmed_fastq/$(SRR).trimmed.fastq -o fastqc_trimmed
multiqc fastqc_trimmed -o fastqc_trimmed
```
### Discuss whether the QC step made a difference.

The qc steps definitely made a difference on quality-related metrics. Particularly, the qc steps improved the per-base sequence quality, GC content, and per-base N content. Therefore, trimming the data improved the quality. However, the per-base sequence content was not improved after trimming.


