## Annotate a few variants

### Select a few variants that fall in a coding sequence. If the VCF has none, choose a different sample.

Pull metadata for my organism *Mycoplasma genitalium): 
```bash
esearch -db sra -query '"Mycoplasma genitalium"[Organism] AND "wgs"[Strategy] AND "illumina"[Platform] AND "paired"[Layout]' | efetch -format runinfo > runinfo.csv
```

### Predict the effect of each variant either by eye or with a software tool.


### Record the reference codon, the alternate codon, and the amino acid change. Use the genetic code for your organism.

## Questions

### Question 1: Which variants did you annotate, and which gene does each one fall in?  


I annotated four SNPs from the jointly called multisample VCF. Positions are on NZ_CP159789.1. Position 1611 is shared by M6282, M2321, and M6320. The others are each found in one of those samples.


| Postition | Gene | Locus Tag | Gene Product | Strand | CDS range |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 1262 | dnaN | ABS333_RS00005 | DNA polymerase III subunit beta | + | 686-1828 |
| 1611 | dnaN | ABS333_RS00005 | DNA polymerase III subunit beta | + | 686-1828 |
| 4728 | gyrB | ABS333_RS00015 | DNA topoisomerase (ATP-hydrolyzing) subunit B | + | 2845-4797 |
| 5710 | gyrA | ABS333_RS00020 | DNA topoisomerase (ATP-hydrolyzing) subunit A | +	 | 4812-7322 |  


### Question 2: For each variant, what is the reference codon, the alternate codon, and the amino acid change?


| Postition | Gene | Position in Codon | Reference Codon | Alternate codon | Amino acid change |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 1262 | dnaN | 193 (1st base) | GAA | AAA | Glu to Lys |
| 1611 | dnaN | 309 (2nd base) | ATT | ACT | Ile to Thr |
| 4728 | gyrB | 628 (3rd base) | GGT | GGC | Gly to Gly |
| 5710 | gyrA | 300 (2nd base) | GCT | GAT | Ala to Asp |

