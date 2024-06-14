# ACS RFD

## :label: Getting Started

* First, clone the repository (Click the <b><b>Code</b></b> button in the top right corner of the page).
* Copy the URL then Clone repository to your local machine.

* Clone a repo

```markdown
git clone https://github.com/mobileteamKLS/ACS_RFD.git 
```

* First Create a new branch with your Name and Date

```markdown
git checkout -b prasad_21Dec
```

* Make your contribution
* Commit with a relevant message and push the changes to your branch

```markdown
git add .
git commit -m 'Added the Track and Trace screen'
git push origin prasad_21Dec
```

* Create a new pull request from your branch (Click the `New Pull Request` button located at the top of your repo)
* Wait for your PR review and approval from the maintainer.
  
### To get latest code from remote `master` branch
* First checkout to your local `master` branch  

```markdown
git checkout master
```
* Pull changes from remote `master` branch  

```markdown
git pull origin master
```
* Now switch back to your local branch(`prasad_21Dec`)  

```markdown
git checkout prasad_21Dec
```
* Now merge changes from your `master` branch to your local branch(`prasad_21Dec`)  

```markdown
git merge master
```
