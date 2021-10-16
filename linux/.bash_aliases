declare -A custom_aliases

# source:
# https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/git/git.plugin.zsh

custom_aliases[g]="git"
custom_aliases[ga]="git add"
custom_aliases[gaa]="git add --all"

custom_aliases[gb]="git branch"
custom_aliases[gba]="git branch --all"
custom_aliases[gbd]="git branch -d"
custom_aliases[gbD]="git branch -D"
custom_aliases[gbl]="git blame -b -w"

custom_aliases[gc]="git commit -v"
custom_aliases[gc!]="git commit -v --amend"
custom_aliases[gcb]="git checkout -b"
custom_aliases[gcl]="git clone --recurse-submodules"
custom_aliases[gcmsg]="git commit -m"
custom_aliases[gco]="git checkout"
custom_aliases[gcp]="git cherry-pick"

custom_aliases[gd]="git diff"
custom_aliases[gdca]="git diff --cached"
custom_aliases[gdcw]="git diff --cached --word-diff"
custom_aliases[gds]="git diff --cached"  # --staged is a synonym of --cached
custom_aliases[gdt]="git diff-tree --no-commit-id --name-only -r"
custom_aliases[gdw]="git diff --word-diff"

custom_aliases[gf]="git fetch -p"

custom_aliases[ggfl]="git push --force-with-lease"
custom_aliases[ggsup]='git branch --set-upstream-to=origin/$(git branch --show-current)'

custom_aliases[gl]="git pull"
custom_aliases[glg]="git log --stat"
custom_aliases[glgp]="git log --stat -p"
custom_aliases[glgg]="git log --graph"
custom_aliases[glgga]="git log --graph --decorate --all"
custom_aliases[glgm]="git log --graph --max-count=10"
custom_aliases[glo]="git log --oneline --decorate"
custom_aliases[glog]="git log --oneline --decorate --graph"
custom_aliases[gloga]="git log --oneline --decorate --graph --all"

custom_aliases[gm]="git merge"

custom_aliases[gp]="git push"
custom_aliases[gpf]="git push --force-with-lease"
custom_aliases[gpl]="git pull"
custom_aliases[gpsup]='git push --set-upstream origin $(git branch --show-current)'

custom_aliases[gr]="git remote"
custom_aliases[grb]="git rebase"
custom_aliases[grbc]="git rebase --continue"
custom_aliases[grbi]="git rebase -i"
custom_aliases[grh]="git reset"
custom_aliases[grhh]="git reset --hard"
custom_aliases[gru]="git reset --"
custom_aliases[grv]="git remote -v"

custom_aliases[gsb]="git status -b -s"
custom_aliases[gsh]="git show"
custom_aliases[gss]="git status -s"
custom_aliases[gst]="git status"
custom_aliases[gstaa]="git stash --apply"
custom_aliases[gstl]="git stash list"
custom_aliases[gstp]="git stash pop"
custom_aliases[gsts]="git stash show --text"


for alias_name in "${!custom_aliases[@]}"; do
    # apply the alias
    alias $alias_name="${custom_aliases[$alias_name]}"
    # make the bash completions work for aliased commands
    complete -F _complete_alias $alias_name
done
