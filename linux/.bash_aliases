# Aliases compatible with:
# https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/git/git.plugin.zsh

custom_aliases=(
    "g:git"
    "ga:git add"
    "gaa:git add --all"

    "gb:git branch"
    "gba:git branch --all"
    "gbd:git branch -d"
    "gbD:git branch -D"
    "gbl:git blame -b -w"

    "gc:git commit -v"
    "gc!:git commit -v --amend"
    "gcb:git checkout -b"
    "gcl:git clone --recurse-submodules"
    "gcmsg:git commit -m"
    "gco:git checkout"
    "gcp:git cherry-pick"

    "gd:git diff"
    "gdca:git diff --cached"
    "gdcw:git diff --cached --word-diff"
    "gds:git diff --cached"  # --staged is a synonym of --cached
    "gdt:git diff-tree --no-commit-id --name-only -r"
    "gdw:git diff --word-diff"

    "gf:git fetch -p"

    "ggfl:git push --force-with-lease"
    'ggsup:git branch --set-upstream-to=origin/$(git branch --show-current)'

    "gl:git pull"
    "glg:git log --stat"
    "glgp:git log --stat -p"
    "glgg:git log --graph"
    "glgga:git log --graph --decorate --all"
    "glgm:git log --graph --max-count=10"
    "glo:git log --oneline --decorate"
    "glog:git log --oneline --decorate --graph"
    "gloga:git log --oneline --decorate --graph --all"

    "gm:git merge"

    "gp:git push"
    "gpf:git push --force-with-lease"
    "gpl:git pull"
    'gpsup:git push --set-upstream origin $(git branch --show-current)'

    "gr:git remote"
    "grb:git rebase"
    "grbc:git rebase --continue"
    "grbi:git rebase -i"
    "grh:git reset"
    "grhh:git reset --hard"
    "gru:git reset --"
    "grv:git remote -v"

    "gsb:git status -b -s"
    "gsh:git show"
    "gss:git status -s"
    "gst:git status"
    "gstaa:git stash --apply"
    "gstl:git stash list"
    "gstp:git stash pop"
    "gsts:git stash show --text"
)

for entry in "${custom_aliases[@]}"; do
    # Workaround for old bash v3 that ships with macOS.
    # Source: https://stackoverflow.com/a/4444841
    alias_name=${entry%%:*}
    alias_value=${entry#:*}

    # apply the alias
    alias $alias_name="${custom_aliases[$alias_name]}"
    # make the bash completions work for aliased commands
    complete -F _complete_alias $alias_name
done

