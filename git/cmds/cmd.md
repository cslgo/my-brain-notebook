
# [Git Cmd](https://www.atlassian.com/git/glossary)

## git add


## git branch

```shell
# List all of the branches in your repository. 
git branch

# Create a new branch called ＜branch＞. This does not check out the new branch.
git branch <branch>

# Delete the specified branch. 
git branch -d <branch>

# Force delete the specified branch, even if it has unmerged changes.
git branch -D <branch>

# Rename the current branch to ＜branch＞.
git branch -m <branch>

# List all remote branches.
git branch -a

# Creating remote branches
## Add remote repo to local repo config
git remote add new-remote-repo https://bitbucket.com/user/repo.git
## Pushes the crazy-experiment branch to new-remote-repo
git push <new-remote-repo> crazy-experiment~

```

## git checkout


```shell
## You can use git checkout to view the “Make some import changes to hello.txt” commit as follows:
git checkout a1e8fb5
## Move around and review the commit history
git checkout -b new-branch
## For undoing shared public changes
git revert
## For undoing local private changes 
git reset
```

## git pull

```
## 避免拉取合并提交 commit
git pull origin feature --rebase
## or
git pull -r
## or
git pull --no-edit
## 若本地有修改
git stash
git pull -r
git stash pop
```

## git log

```shell
git log --oneline

git log --oneline -5 --author caojiaqing --before "Fri Mar 26 2022"
```

