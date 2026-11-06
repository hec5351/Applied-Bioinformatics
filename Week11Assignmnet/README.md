## Look at a wide region (millions of bases wide). How are the two sample types different?
<img width="600" height="300" alt="Screenshot 2026-11-06 at 5 25 05 PM" src="https://github.com/user-attachments/assets/3f4ad5eb-9944-43cf-8251-e73d6597f082" />  


The differences are mostly between samples, not between replicates. The UHR samples have higher peaks.  


## Navigate across the genome. How consistent are the replicates?
The replicates are very consistent. Three replicates have peaks within each type at the same positions and at similar heights. 


## Find a gene that is not expressed in any of the samples. 
<img width="600" height="300" alt="Screenshot 2026-11-06 at 5 34 03 PM" src="https://github.com/user-attachments/assets/aca0915b-3f17-467a-bb43-c772a9faa328" />  


APOL4.  


## Find a gene that is very strongly expressed in all samples. What is its coverage?
<img width="600" height="300" alt="Screenshot 2026-11-06 at 5 40 28 PM" src="https://github.com/user-attachments/assets/fc321e42-5aac-485f-a211-a46ac4e61efb" />  

CBX6. The coverage starts around 39 Mb in all six samples.

## Can you identify the transcripts that are expressed? Sometimes you can only exclude some candidates.  

Considering where the coverage starts, transcript 1 must be expressed.

You can’t rule out transcript 2. Every part of it overlaps transcript 1, so any reads on it could come from either one.

Transcript 3 is unlikely but can’t be fully excluded. Most of its region is intron in the other two transcripts, and coverage there is low. That suggests transcript 3 is absent or only weakly expressed.  


## Can you find a gene/transcript where the expression is clearly different between the two sample types? What is the fold change?
<img width="600" height="300" alt="Screenshot 2026-11-06 at 5 36 27 PM" src="https://github.com/user-attachments/assets/ff89c75f-bd89-486b-a0b6-3212fd9f9f12" />  


IGLL5. UHR has a large peak that sets the 0-480 scale, while HBR sits around 0. Therefore, it is only expressed in UHR and effectively absent from HBR.  


## Is the transcript upregulated or downregulated?  

IGLL5 is upregulated in UHR compared with HBR.

## How certain are you that it is not a random fluctuation? Why?
I can be certain it is not a random fluctuation because all three replicates of each type agree. The differences also appear across the gene, not at one single base.

