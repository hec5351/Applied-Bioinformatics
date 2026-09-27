## Question 1: Explain how you arrived at N  


Formula from Claude: N = (desired coverage x genome size) / average read length


Coverage = 10x


Mycoplasma genitalium genome size = 580,000 bp.


Mycoplasma genitalium length = bases/read spots. This means: 10,900,00/108.852 = 100 bp (https://trace.ncbi.nlm.nih.gov/Traces/?view=run_browser&page_size=10&acc=SRR39974648&display=metadata).  


N = (10 x 2580,076) / 100 = 57,938 reads. I then divided this number by 2 since my run is paired-end: N = 28970.


## Question 2: What percent of the reads align?  


51793 + 0 mapped (89.25% : N/A). This means that almost 90% of the reads aligned.


## Question 3: What do the alignments look like? Do the reads show errors or variations?  
To get the error rate:  

```bash
samtools stats bam/Mycoplasma_genitalium.bam | grep ^SN
```
output:
error rate:     5.288119e-03    # mismatches / bases mapped (cigar)  


This means that the error rate is very low (<1). No large structural variants. 


## Question 4: Is the coverage uniform?  
To see the coverage:
```bash
samtools coverage bam/Mycoplasma_genitalium.bam
```
The output tells me that the coverage is only 0.81%, meaning that the coverage is not uniform and is likely all concentrated in one spot.


## Question 5: Include the commands needed to run the Makefile and a screenshot of the BAM file in IGV.  


commands:
```bash
pixi add seqkit bwa samtools
make all
```


screenshot of BAM file in IGV:
<img width="862" height="327" alt="Screenshot 2026-09-27 at 3 46 43 PM" src="https://github.com/user-attachments/assets/0947d5b7-6e80-4ad9-b573-17068d410ff1" />

