
# --amend amend previous commit
git commit --amend -m "feat: some feature"

# --amend amend no-edit previous commit
git commit --amend --no-edit


# --rebase latest previous 4 commit
git rebase -i  HEAD~4

error: cannot 'fixup' without a previous commit
You can fix this with 'git rebase --edit-todo' and then run 'git rebase --continue'.
Or you can abort the rebase with 'git rebase --abort'.

# pull and merge to master no commmit node
git pull origin master --rebase
