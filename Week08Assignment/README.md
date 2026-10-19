## Annotate a few variants

### Select a few variants that fall in a coding sequence. If the VCF has none, choose a different sample.

Pull metadata for my organism *Mycoplasma genitalium): 
```bash
esearch -db sra -query '"Mycoplasma genitalium"[Organism] AND "wgs"[Strategy] AND "illumina"[Platform] AND "paired"[Layout]' | efetch -format runinfo > runinfo.csv
```

### Predict the effect of each variant either by eye or with a software tool.
I annotated four SNPs from the jointly called multisample VCF, all in coding sequences. Positions are on NZ_CP159789.1.  


| Postition | Gene | Locus Tag | Gene Product | Strand
| --- | --- | --- |
| 1262 | dnaN | ABS333_RS00005 | DNA polymerase III subunit beta | + | 	686-1828
| 1611 | 	dnaN | Row 2, Cell 3 |



| Position | Gene | Locus Tag | 
| --- | --- | --- |
| Row 1, Cell 1 | Row 1, Cell 2 | Row 1, Cell 3 |
| Row 2, Cell 1 | Row 2, Cell 2 | Row 2, Cell 3 |


| Header 1 | Header 2 | Header 3 |
| --- | --- | --- |
| Row 1, Cell 1 | Row 1, Cell 2 | Row 1, Cell 3 |
| Row 2, Cell 1 | Row 2, Cell 2 | Row 2, Cell 3 |


### Record the reference codon, the alternate codon, and the amino acid change. Use the genetic code for your organism.

## Questions

### Question 1: Which variants did you annotate, and which gene does each one fall in?


### Question 2: For each variant, what is the reference codon, the alternate codon, and the amino acid change?

