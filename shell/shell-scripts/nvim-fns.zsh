# My shell utitilies for use with Neovim.

# Shorthand for 'nvim'. Additionally, opens CWD as dirbuf if there are no
# arguments.
function nv() {
    if [ -n "$1" ]; then
        local arg="$1"
    else
        local arg="."
    fi

    nvim ${arg}
}

# Open neovim against a temporary file.
function nvt() {
    local f
    f=$(mktemp)
    trap "rm -f $f" EXIT
    nvim "$f"
}
