## Question 1: Summarize the project: the assay, the organism, the number of samples, and the control and condition.  

1. Assay: ChIP-seq, single-end, 51 bp reads.
2. Organism: Escherichia coli K-12 MG1655 (RefSeq GCF_000005845.2, ASM584v2; 4,641,652 bp).
3. Number of Samples:
4. Source: Peano et al. 2015, Sci Rep 5:10469. BioProject/study SRP041323 (experiment SRX523029).
5. Design: two biological replicates, each with an IP sample and an Input (control) sample.
6. Control and condition: The Input samples are the control (background); the IP samples are the condition. Both IP replicates are compared against the merged Input of the two replicates. (SRR1285991 and SRR1285993 are ip; SRR1285992 and SRR1285994 are input).

## Question 2: Describe how to run the workflow so a reviewer can reproduce it.  

```bash
micromamba create -n chipseq -c conda-forge -c bioconda bwa samtools bedtools macs3 sra-tools parallel
micromamba activate chipseq
make batch        # download the genome, index it, and align every sample in design.csv (in parallel)
make background   # merge the Input BAMs into bam/background.bam
make peaks        # call peaks for each IP sample against the background
make report       # number of peaks per IP sample
make compare      # overlap of the peaks of the two replicates
make igv          # load the BAMs, peaks and annotation in IGV (IGV must be open, port 60151 enabled)
```

## Question 3: How many peaks were called in each sample?
1. SRR1285991: 70 peaks
2. : 3 peaks


## Question 4: How consistent are the peak calls within replicates? Show one region where the replicates agree and one region where they do not. Include screenshots of both regions from IGV.  

Of replicate 1's 70 peaks, only 2 overlap a replicate 2 peak (make compare), so 68 are found in replicate 1 only. By peak lists alone the replicates agree poorly.  

#### Agreeing region: NC_000913.3:1,258,622-1,258,940.
<img width="650" height="400" alt="Screenshot 2026-11-01 at 7 00 51 PM" src="https://github.com/user-attachments/assets/e45a1eba-f09a-4d5d-9be6-3dab8943718e" /> 


#### Disagreeing region: NC_000913.3:1,769,606-1,769,856.
<img width="650" height="400" alt="Screenshot 2026-11-01 at 7 01 08 PM" src="https://github.com/user-attachments/assets/12360103-c5be-4759-bfcd-496edcf20c3c" />
