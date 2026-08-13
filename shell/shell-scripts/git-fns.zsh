# My shell utitilies for use with git.

# Like gco (git checkout), but with worktrees.
function gwco() {
    local branch="$1"
    local leaf="${branch##*/}"
    git worktree add "wt/$leaf" $branch
    cd "wt/$leaf"
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

# Like gbD (git branch --delete), but with worktrees. Assumes that branch `foo/bar/baz` is checked out at `wt/baz`
function gwbD() {
    local branch="$1"
    local leaf="${branch##*/}"
    git worktree remove "wt/$leaf"
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

# Review commits one by one.
function review_next() {
    local start=$1 end=$2
    if git merge-base --is-ancestor "$start" HEAD 2>/dev/null \
        && git merge-base --is-ancestor HEAD "$end" 2>/dev/null; then
        local next
        next=$(git rev-list --reverse --ancestry-path "HEAD..$end" | head -1)
        if [ -z "$next" ]; then
            git checkout "$start"
            echo "↩︎  wrapped back to first commit"
        else
            git checkout "$next"
        fi
    else
        git checkout "$start"
        echo "⚠︎  jumped to first commit (was off-range)"
    fi

    local pos total
    pos=$(git rev-list --count "$start..HEAD")
    total=$(git rev-list --count "$start..$end")
    echo ">>> [$((pos+1))/$((total+1))]"
}
