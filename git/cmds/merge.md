[reference](https://www.atlassian.com/git/tutorials/using-branches/git-merge#:~:text=Git%20merging%20combines%20sequences%20of,conflict%20in%20both%20commit%20sequences.)

Git merge

```shell
# Start a new feature
git checkout -b new-feature main
# Edit some files
git add <file>
git commit -m "Start a feature"
# Edit some files
git add <file>
git commit -m "Finish a feature"
# Develop the main branch
git checkout main
# Edit some files
git add <file>
git commit -m "Make some super-stable changes to main"
# Merge in the new-feature branch
git merge new-feature
# Delete the new-feature
git branch -d new-feature
# Avoid faster-forward, always generates a merge commit
git merge --no-ff <branch>
# Discard the merged
git merge --abort
```

Git merge conflicts

```shell
$ mkdir git-merge-test
$ cd git-merge-test
$ git init .
$ echo "this is some content to mess with" > merge.txt
$ git add merge.txt
$ git commit -am"we are commiting the inital content"
[main (root-commit) d48e74c] we are commiting the inital content
1 file changed, 1 insertion(+)
create mode 100644 merge.txt

$ git checkout -b new_branch_to_merge_later
$ echo "totally different content to merge later" > merge.txt
$ git commit -am"edited the content of merge.txt to cause a conflict"
[new_branch_to_merge_later 6282319] edited the content of merge.txt to cause a conflict
1 file changed, 1 insertion(+), 1 deletion(-)

$ git checkout main
Switched to branch 'main'
$ echo "content to append" >> merge.txt
$ git commit -am"appended content to merge.txt"
[main 24fbe3c] appended content to merge.txt
1 file changed, 1 insertion(+)
$ git merge new_branch_to_merge_later
Auto-merging merge.txt
CONFLICT (content): Merge conflict in merge.txt
Automatic merge failed; fix conflicts and then commit the result.

$ git status
On branch main
You have unmerged paths.
(fix conflicts and run "git commit")
(use "git merge --abort" to abort the merge)

Unmerged paths:
(use "git add <file>..." to mark resolution)

both modified:   merge.txt

$ cat merge.txt
<<<<<<< HEAD
this is some content to mess with
content to append
=======
totally different content to merge later
>>>>>>> new_branch_to_merge_later


```

Git commands that can help resolve merge conflicts

```shell
## The status command is in frequent use when a working with Git and during a merge it will help identify conflicted files.
git status

## Passing the --merge argument to the git log command will produce a log with a list of commits that conflict between the merging branches.
git log --merge

## diff helps find differences between states of a repository/files. This is useful in predicting and preventing merge conflicts.
git diff

## checkout can be used for undoing changes to files, or for changing branches
git checkout

## reset can be used to undo changes to the working directory and staging area.
git reset --mixed

## Executing git merge with the --abort option will exit from the merge process and return the branch to the state before the merge began.
git merge --abort

## Git reset can be used during a merge conflict to reset conflicted files to a know good state
git reset

```

