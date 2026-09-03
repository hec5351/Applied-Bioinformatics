# Step 1: Obtain Genomic Data
## Question 1
#### describe the genome selected and how the Makefile should be used.
The genome I selected is _Apis florea_ (little honeybee). ACC: 048593485.1. The Makefile is used to download the .fasta file from the NCBI Genome Database using the accession number.


#### Process for Makefile:
```bash
mkdir Week02
cd Week02/
nano Makefile
```

#### Makefile contents:
```bash
ACC = GCF_048593485.1

all: $(ACC).fasta

$(ACC).fasta:
	datasets download genome accession $(ACC) --include genome --filename $(ACC).zip
	unzip -o $(ACC).zip -d $(ACC)_tmp
	cp $(ACC)_tmp/ncbi_dataset/data/$(ACC)/*.fna $(ACC).fasta
	rm -rf $(ACC).zip $(ACC)_tmp

clean:
	rm -f $(ACC).fasta
```


#### Process to download .fasta from NCBI using pixi:
```bash
cd Week02/
pixi run make
```


## Question 2
#### How large is the genome? How many chromosomes does it have?
According to NCBI, the genome size is 221.6 Mb, and it has 16 chromosomes. 


## Question 3
#### How many annotations are in the annotation file?
The annotation file is the .gff file. There are 13316 annotations.
input:
```bash
awk '$3=="gene"' ./GCF_048593485.1_annotated/ncbi_dataset/data/GCF_048593485.1/genomic.gff | wc -l
```


## Question 4
#### How complete is this genomic build in your opinion?
This genome is at the contig level of assembly, so it is fairly incomplete in my opinion.

# Step 2: Visualize a Genome
## Question 1
#### How tightly packed are the genes in this genome? Estimate the gene-to-gene distance via the browser.
## Question 2
#### Pick a coordinate on the chromosome and visually inspect the sequence regions around it.
## Question 3
#### Describe all six reading frames (codons) that the coordinate could be part of.
## Question 4
#### Identify the type of feature displayed as a data track.
## Question 5
#### Color features by their strand orientation.
