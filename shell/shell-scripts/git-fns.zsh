# My shell utitilies for use with git.

# Like gco (git checkout), but with worktrees.
function gwco() {
    local branch="$1"
    git worktree add "wt/$branch" $branch
    cd "wt/$branch"
}

# New worktree from branch name.
function gwn() {
    local branch="$1"
    local cmd1="git branch $branch"
    echo "$cmd1"
    eval "$cmd1"

    local path="wt/${branch:gs/\//-/}"
    local cmd2="git worktree add $path $branch"
    echo "$cmd2"
    eval "$cmd2"
}

# Like gbD (git branch --delete), but with worktrees.
function gwbD() {
    local branch="$1"
    local path=$(git worktree list | grep '\['"$branch"'\]' | awk '{print $1}')
    git worktree remove "$path"
}

# Rebase against a common ancestor.
function git-rebase-ancestor () {
    if [ -n "$1" ]; then
        local other="$1"
    else
        echo "Usage: git-rebase-ancestor <main-branch>"
        return 1
    fi
    local current=$(git rev-parse --abbrev-ref HEAD)
    git rebase --onto $other $(git merge-base $other $current) $current
}

