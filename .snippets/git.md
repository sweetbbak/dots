% git

# checkout a branch from a fork
git checkout -b <forked_branch> && git pull origin pull/<pr_number>/head

# list all branches containing a pattern
git branch -r | awk -F/ '/<pattern>/{print $2}'

# delete all branches containing a pattern
git branch -r | awk -F/ '/<pattern>/{print $2}' | xargs -I {} git push origin :{}

# create an annotated tag
git tag -a <tag_name> -m "<tag description>"

# push tag to remote
git push --follow-tags

# add files by pattern
git diff --name-only | grep '<pattern>' | xargs -n 1 -t git add

# committing deleted and modified files 
$ git commit -am "changing and deleting files" (works for dotbare and dotfiles)

$ git add -A stages All (include new files, modified and deleted)
$ git add . stages new and modified, without deleted
$ git add -u stages modified and deleted, without new
git commit -m "..." then commit