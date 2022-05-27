# General GitHub Notes

## Fetch all remote branches

```
git branch -r | grep -v '\->' | while read remote; do git branch --track "${remote#origin/}" "$remote"; done
git fetch --all
git pull --all
```


## Merge develop back into 2.4

```
git add foo
git commit
git push origin 2.4
git checkout develop
git pull origin develop
git merge --no-ff 2.4
git push origin develop
```

## Converting git repo to bare

### Pre-

:warning: Make sure you have ALL your branches merged with the main branch!

### Copy your local copy to remote server

```
 scp -r my_local_git_repo remote_server:
```

### Delete all branches

```
$ git branch
* main
  working
$ git branch -d working
Deleted branch working (was eb2cc05).
```

### Convert from "normal" to bare

```
git config --bool core.bare true
```

### Clone locally

```
git clone ssh://aggli/home/steve/code/gpg
```

## Syncing a fork

### Configuring a remote for a fork

[Source](https://help.github.com/articles/configuring-a-remote-for-a-fork/)

Make sure you see an upstream in the remotes

```
git remote -v
```

If not add it

```
git remote add upstream https://github.com/ORIGINAL_OWNER/ORIGINAL_REPOSITORY.git
```

### Rename master to main

[Source](https://github.com/github/renaming)

```bash
git branch -m master main
git fetch origin
git branch -u origin/main main
git remote set-head origin -a
```

### Sync

[Source](https://help.github.com/articles/syncing-a-fork/)

```
git fetch upstream
git checkout main
git merge upstream/main
git push
```

## Ignore permissions

```
git config core.fileMode false
```

From git-config(1):

```
   core.fileMode
       If false, the executable bit differences between the index and the
       working copy are ignored; useful on broken filesystems like FAT.
       See git-update-index(1). True by default.
```

The -c flag can be used to set this option for one-off commands:

```
git -c core.fileMode=false diff
```

And the --global flag will make it be the default behavior for the logged in user.

```
git config --global core.fileMode false
```

## git ressources

[git Ready](http://gitready.com)

[gitHub](http://github.com)

[gitOrious](https://gitorious.org/)

## quick reference (aka. dirty notes)

```
$ git clone https://github.com/CIRCL/traceroute-circl.git
$ git remote -v show
origin  https://github.com/CIRCL/traceroute-circl.git (fetch)
origin  https://github.com/CIRCL/traceroute-circl.git (push)
$ git remote show
origin
$ git branch
* main
$ git branch my-devel-branch
$ git branch
* main
my-devel-branch
$ git checkout my-devel-branch
Switched to branch 'my-devel-branch'
$ git branch
main
* my-devel-branch
$ git status
# On branch my-devel-branch
nothing to commit (working directory clean)

# The following command combines a merge with the switch to the new branch
$ git checkout -m

$ git branch -d my-devel-branch
Deleted branch my-devel-branch (was 1551384).

$ git commit
$ git add

$ git commit $FILES
$ git add $FILES

$ git commit -a
$ git add -A


$ git diff main my-devel-branch
$ git log

$ git fetch (only fetch new references, but no
$ git pull (fetch & merge)

$ git merge origin main
$ git push origin
$ git push origin my-devel-branch
```

To be investigated:

```
git diff my-devel-branch:
git diff origin/main
git merge my-devel-branch:
git merge
git merge my-devel-branch:text
git fetch origin
```

Some questions to be answered:

* Is HEAD == main <--- The HEAD notation is only supported for historical reasons, do NOT use src: [git-merge](https://git-scm.com/docs/git-merge)
* Is : == origin
* what is ^

# Config

˜/.gitconfig
```
[core]
    editor = vim
    ignorecase = true
[user]
    name = Steve Clement
    email = steve@localhost.lu
    signingkey = 9BE4AEE9

[color]
    diff = auto
    status = auto
    branch = auto
```


## Github Hints

Global setup:

Set up git
```
  git config --global user.name "your_username"
  git config --global user.email your@email.lu
```

Next steps:

```
  mkdir myNewRepo
  cd myNewRepo
  git init
  touch README
  git add README
  git commit -m 'first commit'
  git remote add origin git@github.com:SteveClement/myNewRepo.git
  git push -u origin main
```

Existing Git Repo?

```
  cd existing_git_repo
  git remote add origin git@github.com:SteveClement/myNewRepo.git
  git push -u origin main
```

## changing remote

Recently I had the issue that I pulled a repo by specifying the IP address as opposed to a hostname.
Let's change that to a hostname.

```
Steves-MacBook-Air:sysadmin steve$ git remote -v show
origin  192.168.1.53:sysadmin.git (fetch)
origin  192.168.1.53:sysadmin.git (push)
Steves-MacBook-Air:sysadmin steve$ git remote rm origin
Steves-MacBook-Air:sysadmin steve$ git remote -v show
Steves-MacBook-Air:sysadmin steve$ git remote add origin bsdell:sysadmin.git
Steves-MacBook-Air:sysadmin steve$ git remote -v show
origin  bsdell:sysadmin.git (fetch)
origin  bsdell:sysadmin.git (push)
```
