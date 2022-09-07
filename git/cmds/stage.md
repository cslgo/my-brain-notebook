git stage
===

```shell
## Stashing your work
$ git stash
Saved working directory and index state WIP on main: 5002d47 our new homepage
HEAD is now at 5002d47 our new homepage

## You can reapply previously stashed changes with git stash pop
$ git stash pop
On branch main
Changes to be committed:

    new file:   style.css

Changes not staged for commit:

    modified:   index.html

Dropped refs/stash@{0} (32b3aa1d185dfe6d57b3c3cc3b32cbf3e380cc6a)

## Alternatively, you can reapply the changes to your working copy and keep them in your stash with git stash apply. This is useful if you want to apply the same stashed changes to multiple branches.
$ git stash apply
On branch main
Changes to be committed:

    new file:   style.css

Changes not staged for commit:

    modified:   index.html

## Adding the -u option (or --include-untracked) tells git stash to also stash your untracked files
$ git status
On branch main
Changes to be committed:

    new file:   style.css

Changes not staged for commit:

    modified:   index.html

Untracked files:

    script.js
$ git stash -u
Saved working directory and index state WIP on main: 5002d47 our new homepage
HEAD is now at 5002d47 our new homepage

$ git status
On branch main
nothing to commit, working tree clean

## 
$ git stash list
stash@{0}: WIP on main: 5002d47 our new homepage
stash@{1}: WIP on main: 5002d47 our new homepage
stash@{2}: WIP on main: 5002d47 our new homepage

## To provide a bit more context, it's good practice to annotate your stashes with a description, using git stash save "message"
$ git stash save "add style to our site"
Saved working directory and index state On main: add style to our site
HEAD is now at 5002d47 our new homepage

$ git stash list
stash@{0}: On main: add style to our site
stash@{1}: WIP on main: 5002d47 our new homepage
stash@{2}: WIP on main: 5002d47 our new homepage

## By default, git stash pop will re-apply the most recently created stash: stash@{0}。You can choose which stash to re-apply by passing its identifier as the last argument, for example:
$ git stash pop stash@{2}

## You can view a summary of a stash with git stash show:
$ git stash show
 index.html | 1 +
 style.css | 3 +++
 2 files changed, 4 insertions(+)

 ## Or pass the -p option (or --patch) to view the full diff of a stash:

$ git stash show -p
diff --git a/style.css b/style.css
new file mode 100644
index 0000000..d92368b
--- /dev/null
+++ b/style.css
@@ -0,0 +1,3 @@
+* {
+  text-decoration: blink;
+}
diff --git a/index.html b/index.html
index 9daeafb..ebdcbd2 100644
--- a/index.html
+++ b/index.html
@@ -1 +1,2 @@
+<link rel="stylesheet" href="style.css"/>

## Creating a branch from your stash
$ git stash branch add-stylesheet stash@{1}
Switched to a new branch 'add-stylesheet'
On branch add-stylesheet
Changes to be committed:

    new file:   style.css

Changes not staged for commit:

    modified:   index.html

Dropped refs/stash@{1} (32b3aa1d185dfe6d57b3c3cc3b32cbf3e380cc6a)

## Cleaning up your stash
$ git stash drop stash@{1}
Dropped stash@{1} (17e2697fd8251df6163117cb3d58c1f62a5e7cdb)
## Or you can delete all of your stashes with:
$ git stash clear

## More
$ git log --oneline --graph stash@{0}
*-.   953ddde WIP on main: 5002d47 our new homepage
|\ \ 
| | * 24b35a1 untracked files on main: 5002d47 our new homepage
| * 7023dd4 index on main: 5002d47 our new homepage
|/ 
* 5002d47 our new homepage


```