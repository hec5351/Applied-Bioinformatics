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


## Question 4 
#### Does the README.md make it clear how to run the code and what the outcomes are?


## Question 5 
#### Verify that the results are reproducible. Does the code do what the author says it does?


## 
#### Question 6 Ask the AI Agent to compare your solution to theirs.


## Question 7 
#### Ask the AI Agent to evaluate which solution it thinks is better.


## Question 8
#### In a paragraph or two, summarize your findings above.


## Question 9
#### Make a change to the forked repository that addresses an issue you found.


## Question 10
#### Commit and push the change to your fork.


## On the GitHub interface create a pull request to the original repository.
