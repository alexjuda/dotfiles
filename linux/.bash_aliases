declare -A custom_aliases

custom_aliases[g]="git"
custom_aliases[g]="git"
custom_aliases[ga]="git add"
custom_aliases[gb]="git branch"
custom_aliases[gba]="git branch --all"
custom_aliases[gc]="git commit"
custom_aliases[gco]="git checkout"
custom_aliases[gf]="git fetch -p"
custom_aliases[ggfl]="git push --force-with-lease"
custom_aliases[gl]="git log --graph --all"
custom_aliases[gm]="git merge"
custom_aliases[gp]="git push"
custom_aliases[gpl]="git pull"
custom_aliases[gpsup]='git push --set-upstream origin $(git branch --show-current)'
custom_aliases[grb]="git rebase"
custom_aliases[gr]="git reset"
custom_aliases[grhh]="git reset --hard"
custom_aliases[gs]="git status -b -s"
custom_aliases[gst]="git stash"
custom_aliases[gsta]="git stash --apply"
custom_aliases[gstp]="git stash pop"


for alias_name in "${!custom_aliases[@]}"; do
    # apply the alias
    alias $alias_name="${custom_aliases[$alias_name]}"
    # make the bash completions work for aliased commands
    complete -F _complete_alias $alias_name
done
