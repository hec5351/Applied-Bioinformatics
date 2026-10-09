## How many variants were called?
14 variants were called.
## What kinds of variants are present?
13 SNPs and 1 indel. Ts/Tv is 0.62
(5 transitions, 8 transversions), which is low. This is based on only 13 SNPs,
so it is not statistically meaningful, but a low ratio can hint at some
false positives, since real SNPs usually favor transitions.
## Which calls look like true variants, and which look like errors?

## Are the calls supported by the alignments?

## Include the commands needed to run the Makefile and a screenshot of the VCF file in IGV.
To run the Makefile:
```bash
make all
```
## Limitations
Reads cover only ~0.8% of the genome, so these 14 calls say little about
the genome as a whole. Per-position depth was capped at 100 reads (-d 100).
