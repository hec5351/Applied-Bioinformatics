## Question 1 
#### Fork the clone one of the repositories you were assigned to review.
First, fork the directory. The directory I chose was https://github.com/asusanyamshah/Shah_BMMB852. On the git directory you want to clone:
<img width="500" height="300" alt="Screenshot 2026-09-11 at 3 17 51 PM" src="https://github.com/user-attachments/assets/59ce9782-ceeb-4186-ab29-6d427667550d" />
<img width="500" height="300" alt="Screenshot 2026-09-11 at 3 19 25 PM" src="https://github.com/user-attachments/assets/b986d254-bdba-497d-b771-364f1aabd20f" />





Now, you will have a fork of the directory. If you hover your mouse over the fork option again, you should see:<img width="500" height="300" alt="Screenshot 2026-09-11 at 3 21 11 PM" src="https://github.com/user-attachments/assets/5384333f-1a1a-463e-b680-80aaab8bb211" />


## Question 2 
#### Verify that the code is not doing something dangerous.
prompt: How would i verify that the code in the directory I forked is not doing something dangerous?


AI respoonse:
"For most bioinformatics repos (Makefiles, shell scripts, Python), this is usually enough:
```
cat Makefile
cat *.sh
cat *.py
```
Look specifically for:

curl ... | bash or wget ... | sh — piping a download straight into a shell interpreter, no inspection first. This is the single riskiest pattern to watch for.
sudo — anything requesting elevated permissions
rm -rf with variables that could expand unexpectedly (rm -rf $SOMEVAR/ where $SOMEVAR is empty deletes from /)
Network calls to unfamiliar domains
eval, exec, or base64-decoded strings being executed
Environment variable exfiltration (e.g., scripts that read .env, SSH keys, AWS credentials and send them somewhere)."


After running this script, the Makefile looked clean. There were no .sh files or .py files.

## Question 3 
#### Evaluate the README.md of the assignment.
This ReadME does not include a description of what the ReadME is about or how the Makefile should be used. There is also no specific code to run in the ReadME file. Also, there are no directions for creating the Makefile or its contents.

## Question 4 
#### Does the README.md make it clear how to run the code and what the outcomes are?
The ReadME makes the expected outcomes clear, but how to run the code is less clear.

## Question 5 
#### Verify that the results are reproducible. Does the code do what the author says it does?
At first, it was throwing me an error that said:
```
make: Nothing to be done for `all'.
```


I asked AI what was wrong using this prompt: I have a Makefile and want to run it using pixi. "make" and "pixi run make" both throw the error:make: Nothing to be done for `all'. I am in the directory with the Makefile. AI told me that I need to delete the previously created sequences folder, as make thinks that it has nothing to do since the .fasta and .gff were already downloaded in the directory. I deleted the sequences folder using the following code:
```
rm -rf sequences
```


Then, I was able to download the .fasta and .gff using:
```
make
```


## Question 6
#### Ask the AI Agent to compare your solution to theirs.
The contents of my peer's Makefile:
```
ACCESSION := NC_007558.1
NCBI_URL := https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi
SEQUENCES_DIR := sequences
FASTA := $(SEQUENCES_DIR)/$(ACCESSION).fasta
GFF := $(SEQUENCES_DIR)/$(ACCESSION).gff

.PHONY: all download clean

all: download

download: $(FASTA) $(GFF)


$(FASTA):
	mkdir -p $(SEQUENCES_DIR)
	curl -fL "$(NCBI_URL)?db=nuccore&id=$(ACCESSION)&rettype=fasta&retmode=text" -o $@

$(GFF):
	mkdir -p $(SEQUENCES_DIR)<img width="746" height="412" alt="Screenshot 2026-09-11 at 4 09 02 PM" src="https://github.com/user-attachments/assets/46ba0174-0a94-4b33-9fd4-ce7f271d1c38" />

	curl -fL "$(NCBI_URL)?db=nuccore&id=$(ACCESSION)&rettype=gff3&retmode=text" -o $@

clean:
	rm -f $(FASTA) $(GFF)
```



The contents of my Makefile:
```
ACC = GCF_048593485.1

all: $(ACC).fasta

$(ACC).fasta:
	datasets download genome accession $(ACC) --include genome --filename $(ACC).zip
	unzip -o $(ACC).zip -d $(ACC)_tmp
	cp $(ACC)_tmp/ncbi_dataset/data/$(ACC)/*.fna $(ACC).fasta
	rm -rf $(ACC).zip $(ACC)_tmp

clean:
	rm -f $(ACC).fasta
```

The prompt I gave AI: My class assignment is to create a Makefile and download a genome .fasta and .gff file from NCBI. Compare my solution to my peer's solution. *I then pasted my solution and my peer's solution.*   



AI response: <img width="500" height="300" alt="Screenshot 2026-09-11 at 4 09 30 PM" src="https://github.com/user-attachments/assets/749e4169-3e7b-42c5-904f-df098ed04101" />




## Question 7 
#### Ask the AI Agent to evaluate which solution it thinks is better. 
Prompt I used: Evaluate which solution is better.   



AI Response:   



<img width="778" height="748" alt="Screenshot 2026-09-11 at 4 11 24 PM" src="https://github.com/user-attachments/assets/23c4afb7-ca2c-45ad-a140-3d1358e724f1" />



## Question 8
#### In a paragraph or two, summarize your findings above.


## Question 9
#### Make a change to the forked repository that addresses an issue you found.


## Question 10
#### Commit and push the change to your fork.


## On the GitHub interface create a pull request to the original repository.
