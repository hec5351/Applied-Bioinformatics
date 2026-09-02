# Week 01 Assignment
## Question 2
#### Install an AI ready code editor as described on the page. Mention in your README the editor you chose.
AI Ready Code Editor: Visual Studio Code

## Question 6
#### Q: What version is your samtools command in the bioinfo environment?
Version: 1.24
## Question 7
#### Q: Show commands needed to create a nested directory structure.
A nested directory is a directory located inside a directory.   


Input:  
```bash
mkdir directory
```
Output: Created a new directory called directory.  


Input:  
```bash
cd directory
```
Output: Changed into the directory.


Input:  
```bash
mkdir nesteddirectory
```
Output: Made a nested directory called nesteddirectory. 

## Question 8
#### Q: Show commands that create files in different directories
Input:  
```bash
 mkdir directory
cd directory 
>createfile
```
ouput: I first made a new directory, changed into that directory, and then created a file in that directory.  


Input:
```bash
cd ../ 
mkdir directory2
cd directory2
>createfile2
```
ouput: I first changed out of my first new directory, made a second new directory, changed into the second new directory, and then created a new file in that directory.  



## Question 9
#### Q: Show how to access these files using relative and absolute paths.
relative: 
```bash
cd directory
open . file
```
absolute:
```bash
cd /Users/haleyecurtis/directory/ 
open . file
```
