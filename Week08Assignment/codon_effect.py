#!/usr/bin/env python3
"""Predict the effect of SNPs in coding sequences (translation table 4).

Usage:
    python3 codon_effect.py genome.fasta cds_variants.tsv [POS ...]

cds_variants.tsv is the output of `make -s cds`:
    chrom, pos, ref, alt, one genotype per sample, CDS start, CDS end, strand, attributes
If POS values are given, only those variants are reported.
Assumes single-segment CDS features that start in frame (phase 0).
"""
import sys

# Standard genetic code in TCAG order, with TGA changed to Trp (table 4: Mycoplasma).
BASES = "TCAG"
AA = list("FFLLSSSSYY**CC*WLLLLPPPPHHQQRRRRIIIMTTTTNNKKSSRRVVVVAAAADDEEGGGG")
AA[BASES.index("T") * 16 + BASES.index("G") * 4 + BASES.index("A")] = "W"  # TGA = Trp
CODE = {a + b + c: AA[16 * i + 4 * j + k]
        for i, a in enumerate(BASES) for j, b in enumerate(BASES) for k, c in enumerate(BASES)}
COMP = str.maketrans("ACGT", "TGCA")


def revcomp(s):
    return s.translate(COMP)[::-1]


def read_fasta(path):
    seq, name = [], None
    for line in open(path):
        if line.startswith(">"):
            if name is not None:
                break  # first sequence only
            name = line[1:].split()[0]
        else:
            seq.append(line.strip().upper())
    return "".join(seq)


def attr(attrs, key):
    for item in attrs.split(";"):
        if item.startswith(key + "="):
            return item[len(key) + 1:]
    return ""


def main():
    if len(sys.argv) < 3:
        sys.exit(__doc__)
    genome = read_fasta(sys.argv[1])
    wanted = set(sys.argv[3:])
    print("\t".join(["POS", "GENE", "STRAND", "CODON#", "BASE_IN_CODON", "REF>ALT(gene strand)",
                     "REF_CODON", "ALT_CODON", "REF_AA", "ALT_AA", "EFFECT", "GENOTYPES"]))
    for line in open(sys.argv[2]):
        f = line.rstrip("\n").split("\t")
        if len(f) < 9 or (wanted and f[1] not in wanted):
            continue
        pos, ref, alt = int(f[1]), f[2].upper(), f[3].upper()
        start, end, strand, attrs = int(f[-4]), int(f[-3]), f[-2], f[-1]
        gts = ",".join(f[4:-4])
        gene = attr(attrs, "gene") or attr(attrs, "locus_tag")
        if len(ref) != 1 or len(alt) != 1:
            print(f"{pos}\t{gene}\t{strand}\t-\t-\t{ref}>{alt}\t-\t-\t-\t-\tindel or multiallelic (do by hand)\t{gts}")
            continue
        cds = genome[start - 1:end]
        if strand == "-":
            cds = revcomp(cds)
            i = end - pos
            r, a = revcomp(ref), revcomp(alt)
        else:
            i = pos - start
            r, a = ref, alt
        if cds[i] != r:
            print(f"{pos}\t{gene}\t{strand}\t-\t-\t{r}>{a}\t-\t-\t-\t-\tREF does not match genome ({cds[i]}); check\t{gts}")
            continue
        c0 = 3 * (i // 3)
        rc = cds[c0:c0 + 3]
        ac = rc[:i % 3] + a + rc[i % 3 + 1:]
        ra, aa = CODE[rc], CODE[ac]
        effect = "synonymous" if ra == aa else ("nonsense (stop gained)" if aa == "*" else
                 "stop lost" if ra == "*" else "missense")
        print(f"{pos}\t{gene}\t{strand}\t{i // 3 + 1}\t{i % 3 + 1}\t{r}>{a}\t{rc}\t{ac}\t{ra}\t{aa}\t{effect}\t{gts}")


if __name__ == "__main__":
    main()
