
custom_aliases=(
    # -------------- git aliases ----------------
    # git aliases compatible with:
    # https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/git/git.plugin.zsh
    "g:git"
    "ga:git add"
    "gap:git add --interactive --patch"

    "gb:git branch"
    "gba:git branch --all"
    "gbd:git branch -d"
    "gbD:git branch -D"
    "gbDD:git branch | grep -v 'dev' | grep -v 'main' | xargs git branch -D"
    "gbl:git blame -b -w"

    "gc:git commit -v"
    "gca:git commit -v --amend"  # 'gc!' can't be used in macOS bash
    "gcb:git checkout -b"
    "gcl:git clone --recurse-submodules"
    "gcm:git commit -m"
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

    "gls:git log --stat"
    "glg:git log --graph"
    "glga:git log --graph --decorate --all"
    "glo:git log --oneline --decorate"
    "glog:git log --oneline --decorate --graph --all"
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

    "gsh:git show"
    "gs:git status --untracked-files"
    "gsr:git rev-parse"
    # Copy latest sha and print.
    # Src: https://unix.stackexchange.com/a/273284
    "gsrc:git rev-parse HEAD | tee >(pbcopy)"
    "gss:git status --short --branch --untracked-files"
    "gst:git stash"
    "gsta:git stash push"
    "gstaa:git stash --apply"
    "gstall:git stash push --all"
    "gstl:git stash list"
    "gstp:git stash pop"
    "gsts:git stash show --text"

    # --------------- dir movement --------------
    "cdd:cd ~/Desktop"
    "cdn:cd ~/Documents/notes-synced"

    # --------------- listing dirs --------------
    "l1:tree -L 1"
    "l2:tree -L 2"
    "l3:tree -L 3"
    "l:l1"
    "ll:ls -alhF"
    "la:ls -ah"

    # --------------- shortcuts --------------
    "lg:lazygit"
    "va:source venv/bin/activate"
    "nv:nvim"
    # open last edited file
    "nvl:nvim -c 'e #<1'"
    # enables <C-Z> to hide, Z to show
    "z:fg"
)

for entry in "${custom_aliases[@]}"; do
    # Workaround for old bash v3 that ships with macOS.
    # Source: https://stackoverflow.com/a/4444841
    # "$alias_name = $alias_value"
    # apply the alias
    alias "${entry%%:*}"="${entry#*:}"
    # make the bash completions work for aliased commands
    complete -F _complete_alias $alias_name
done

