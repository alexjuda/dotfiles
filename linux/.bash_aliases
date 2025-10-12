custom_aliases=(
    # -------------- git aliases ----------------
    # git aliases compatible with:
    # https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/git/git.plugin.zsh
    "g:git"
    "ga:git add"
    "gap:git add --interactive --patch"

    "gb:git branch"
    "gba:git branch --all"
    "gbc:git branch --show-current"
    "gbd:git branch -d"
    "gbD:git branch -D"
    "gbDD:git branch | grep -v 'dev' | grep -v 'main' | xargs git branch -D"

    "gc:git commit -v"
    "gca:git commit -v --amend"  # 'gc!' can't be used in macOS bash
    "gcb:git checkout -b"
    "gcm:git commit -m"
    "gco:git checkout"
    "gcp:git cherry-pick"

    "gd:git diff"
    "gds:git diff --cached"  # --staged is a synonym of --cached

    "gf:git fetch -p"

    "ggfl:git push --force-with-lease"

    "glo:git log --oneline --decorate"
    "gloga:git log --oneline --decorate --graph --all"

    "gm:git merge"
    "gmff:git merge --ff-only"

    "gp:git push"
    'gpsup:git push --set-upstream origin $(git branch --show-current)'

    "gpl:git pull --ff-only"
    'gpDO:git push --delete origin'  # needs 1 more arg: explicit branch name

    "gr:git remote -v"
    "grb:git rebase"
    "grba:git rebase --abort"
    "grbc:git rebase --continue"
    "grbi:git rebase -i"
    "grh:git reset"
    "grhh:git reset --hard"
    "grhhu:git reset --hard @{u}"

    "gsh:git show"
    "gs:git status --short --branch --untracked-files"
    "gss:git status --untracked-files"
    # Copy latest sha and print.
    # Src: https://unix.stackexchange.com/a/273284
    "gsrc:git rev-parse HEAD | tee >(pbcopy)"
    "gst:git stash"
    "gsta:git stash apply"
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
    "ll:ls -alhF --color=auto"
    "la:ls -ah --color=auto"

    # --------------- shortcuts --------------
    "lg:lazygit"
    "va:source .venv/bin/activate"
    # open last edited file
    "nvl:nvim -c 'e #<1'"
    "ipytest:pytest --pdbcls=IPython.terminal.debugger:TerminalPdb"
    "y:yazi"
)

# Define aliases
for entry in "${custom_aliases[@]}"; do
    # Workaround for old bash v3 that ships with macOS.
    # Source: https://stackoverflow.com/a/4444841
    # "$alias_name = $alias_value"
    # apply the alias
    alias "${entry%%:*}"="${entry#*:}"
done

# Enable tab completion in zsh. Only needed for root commands.
# src: https://unix.stackexchange.com/a/477909
if [ -v ZSH_VERSION ]; then
    compdef g="git"
    compdef nv="nvim"
fi
