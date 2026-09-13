ACC = GCF_048593485.1
ASM = $(ACC)_ASM4859348v1
BASE = https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/048/593/485/$(ASM)
CURL = curl -L --fail --retry 5 --retry-delay 3 --connect-timeout 20 --speed-limit 1024 --speed-time 30

FASTA = $(ACC).fasta
FASTA_GZ = $(ACC).fna.gz
GFF_RAW = $(ACC).raw.gff.gz
GFF = $(ACC).gff.gz

all: $(FASTA).fai $(GFF).tbi

$(FASTA_GZ):
	$(CURL) $(BASE)/$(ASM)_genomic.fna.gz -o $@

$(GFF_RAW):
	$(CURL) $(BASE)/$(ASM)_genomic.gff.gz -o $@

$(FASTA): $(FASTA_GZ)
	gunzip -c $< > $@

$(GFF): $(GFF_RAW)
	(gunzip -c $< | awk '/^#/ { print }'; gunzip -c $< | awk '/^[^#]/ { print }' | sort -t '	' -k1,1 -k4,4n -k5,5n) | bgzip > $@

$(FASTA).fai: $(FASTA)
	samtools faidx $(FASTA)

$(GFF).tbi: $(GFF)
	tabix -p gff $(GFF)

clean:
	rm -f $(ACC).zip $(FASTA_GZ) $(GFF_RAW) $(FASTA) $(FASTA).fai $(GFF) $(GFF).tbi
