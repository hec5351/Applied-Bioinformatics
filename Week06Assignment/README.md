## Sample 1 Evaluation
<img width="1500" height="500" alt="Screenshot 2026-10-04 at 7 34 02 PM" src="https://github.com/user-attachments/assets/39ca43d5-bcad-419e-84d8-fe7c6e14d711" />  


Sample 1 is viewed as pairs and colored by insert size. Most of the sample appears uniform, with continuous coverage. However, the sample appears to have many small insertions near 15kb. Since there are many insertions near the same spot, this sample may show insertion variation compared to the reference. However, the variation is likely small.


## Sample 2  
<img width="1500" height="500" alt="Screenshot 2026-10-04 at 7 44 36 PM" src="https://github.com/user-attachments/assets/170cc01a-0e73-47e6-b396-baa90f0d2e69" />


Sample 2 is viewed as pairs and colored by insert size. Green, red, and blue appear throughout the sample. This suggests structural variation in the sample. It also suggests mismatches and high variance with the reference genome. 


## Sample 3  
<img width="1500" height="500" alt="Screenshot 2026-10-04 at 7 58 47 PM" src="https://github.com/user-attachments/assets/5c6ec2df-ed8f-4480-96d8-4169f62ec9b5" />  


Sample 3 is viewed as pairs and colored by pair orientation. The coverage histogram seems abnormal, with peaks from 1- 2 kb, 3- 4 kb, and 5-6 kbs. Coverage looks much lower everywhere else in the sample. Where the coverage spikes, there are long columns of green. The increased coverage in certain regions suggests heavy duplication in this sample.


## Sample 4  
<img width="1500" height="500" alt="Screenshot 2026-10-04 at 8 21 51 PM" src="https://github.com/user-attachments/assets/1ef14ed5-5f94-4440-ae26-2c461f602620" />


Sample 4 is colored by insert size. Immediately, I noticed that there is abnormal coverage around 4.5-6kb. Once I zoomed in on this region, I saw that the teal reads were facing the same direction. This orientation, along with the fact that they are all condensed near the same spot, suggests the sample is likely inverted. 


## Sample 5  
### Viewed as pairs and colored by insert size
<img width="1506" height="629" alt="Screenshot 2026-10-04 at 8 28 16 PM" src="https://github.com/user-attachments/assets/87dc36e7-03a9-46f5-aa0a-71fc64708fd7" />  

### Viewed as pairs and colored by insert size and pair orientation
 <img width="1487" height="630" alt="Screenshot 2026-10-04 at 8 34 20 PM" src="https://github.com/user-attachments/assets/8d75b08e-3a49-4039-8a2a-83803c3ad2b9" />


At first glance, this sample looks like it could have a deletion because of the abnormal red column between 4-6.5 kb. However, I do not think it is a deletion because there is no gap in the coverage. After coloring the sample by insert size and pair orientation, I also saw a long column of green reads near the same location. Since the paired-end reads point away from each other, I believe this sample is likely translocated.



