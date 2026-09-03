ACC = GCF_048593485.1

all: $(ACC).fasta

$(ACC).fasta:
	datasets download genome accession $(ACC) --include genome --filename $(ACC).zip
	unzip -o $(ACC).zip -d $(ACC)_tmp
	cp $(ACC)_tmp/ncbi_dataset/data/$(ACC)/*.fna $(ACC).fasta
	rm -rf $(ACC).zip $(ACC)_tmp

clean:
	rm -f $(ACC).fasta
