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
The gene is not tightly packed in the genome. I estimate the gene-to-gene distance to be about 18,000 bp.


## Question 2
#### Pick a coordinate on the chromosome and visually inspect the sequence regions around it.
<img width="1068" height="221" alt="Screenshot 2026-09-03 at 7 27 25 PM" src="https://github.com/user-attachments/assets/ee6645e5-40bf-4290-aee4-8cce6e548a0c" />

## Question 3
#### Describe all six reading frames (codons) that the coordinate could be part of.
IGV has a three-frame translation track. You know this because there are three lines of amino acids under the sequence. Therefore, reading it forward and backward can tell me all six reading frames.
Forwards:
<img width="1068" height="221" alt="Screenshot 2026-09-03 at 7 27 25 PM" src="https://github.com/user-attachments/assets/ee6645e5-40bf-4290-aee4-8cce6e548a0c" />
Backwards:
<img width="1197" height="330" alt="Screenshot 2026-09-03 at 7 37 31 PM" src="https://github.com/user-attachments/assets/8ba47ec6-7727-4337-aa99-d6840dd6a6d4" />


## Question 4
#### Identify the type of feature displayed as a data track.
The feature displayed is a visualization of the sequence, not a gff, bam, or vcf.


## Question 5
#### Color features by their strand orientation.
<img width="482" height="532" alt="Screenshot 2026-09-03 at 7 48 33 PM" src="https://github.com/user-attachments/assets/16c7dd7a-2ab5-4f79-9840-64344b17b97b" />
<img width="858" height="494" alt="Screenshot 2026-09-03 at 7 49 37 PM" src="https://github.com/user-attachments/assets/c5f9f9a5-dced-4942-a6f8-8fafd79b7ca6" />


The negative strand is colored red, while the positive one stays blue.


