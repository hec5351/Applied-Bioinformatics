## How many variants were called?
14 variants were called.
## What kinds of variants are present?
13 SNPs and 1 indel (A>AT insertion at 174069).
5 transitions and 8 transversions (Ts/Tv 0.62). All 14 calls fall in two
places: 2 near 173.8-174.1 kb and 12 within 221.8-221.9 kb, with ten SNPs
packed into 36 bp (221856-221891).  


## Which calls look like true variants, and which look like errors?  

The genome is haploid, so a true variant should
be supported by nearly all reads. Likely true: 174069 (86/91 reads, both
strands), 221914 (24/24, both strands) and 173799 (124/124 reads, but 122
forward vs 2 reverse, so strand-biased). The 221856-221891 cluster is
suspect: depth drops to 8-16 reads, six calls have one REF read, and ten SNPs
in 36 bp is unlikely for independent mutations. It may reflect
mismapped reads from a divergent or repetitive sequence. The QUALA is likely high
(158-225) because QUAL doesn't capture mapping ambiguity.
 


## Are the calls supported by the alignments?  


Yes for the isolated calls. At 221803 and 221914, almost all reads show the alternate base in a solid
column. The cluster at 221856-221891 is different because the alternate bases are
only on a few reads and the same reads carry all of them together. This
indicated one divergent haplotype or reads from a similar sequence mapped
here, not ten independent mutations, so I count it as one uncertain event.
Coverage drops from about 14 reads to a handful where the cluster sits.  


## Include the commands needed to run the Makefile and a screenshot of the VCF file in IGV.
To run the Makefile:
```bash
make all
```


Screeenshot in IGV:
<img width="1502" height="747" alt="Screenshot 2026-10-09 at 2 37 14 PM" src="https://github.com/user-attachments/assets/b91fcd3e-402a-4eed-b880-c5f81e8773d1" />  


## Limitations
Reads cover only ~0.8% of the genome, so these 14 calls say little about
the genome as a whole. Per-position depth was capped at 100 reads (-d 100).
