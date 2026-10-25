## Summarize the bioproject: how many samples, what the project was about etc.

Get bioproject info: 
```bash
efetch -db sra -id SRR39974648 -format runinfo | cut -d, -f1,22,29,30
```

**Website:** https://www.ncbi.nlm.nih.gov/Traces/study/?acc=PRJNA1506641&o=acc_s%3Aa

#### What I learned:
**Project:** PRJNA1506641. 109 runs. All Amplicon libraries made by PCR on on Illumina paired-end.   
**Samples:** Human clinical samples of _Mycoplasmoides genitalium_ collected by Hospital Universitari Vall d’Hebron in Barcelona, Spain, between 2022 and 2025. I chose 10 samples.
**Isolation Sources:** Urine (38), urethral swab (31), pharyngeal swab (12), rectal swab (12), endocervical swab (11), vaginal swab (5).   
**Project purpose:** Not available.

## Describe how to run the workflow, ensuring that it can be reproduced by a reviewer. 

```bash
conda activate bioinfo
conda install -c conda-forge parallel
make batch # all 10 samples, 4 at a time
make merge  # vcf/merged.vcf.gz
make report  # covered bases, depth at covered positions, variants per 
```

## Visualize the results in IGV or and summarize a few findings that seem relevant.
