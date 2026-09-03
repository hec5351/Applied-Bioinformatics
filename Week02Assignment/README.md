# Step 1: Obtain Genomic Data
## Question 1
#### describe the genome selected and how the Makefile should be used.
The genome I selected is _Apis florea_ (little honeybee). ACC: 048593485.1. The Makefile is used to download the .fasta file from the NCBI Genome Database using the accession number.


#### Process for Makefile:
```bash
mkdir Week02/
nano Makefile
```

#### Makeifle contents:
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
ddd
## Question 3
#### How many annotations are in the annotation file?
dddd
#### How complete is this genomic build in your opinion?
## Question 4
#### Add the instructions for running the Makefile

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
