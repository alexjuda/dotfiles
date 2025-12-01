# Note on .zshrc, .zprofile, .zshenv: https://ss64.com/osx/syntax-profile.html.
# tl;dr we need .zshrc.
# * .zprofile is for SSH connection details only
# * .zshenv is for all shells, including non-interactive ones

# Uncomment for tracing slow start up times. Source: https://www.reddit.com/r/zsh/comments/kums6q/zsh_very_slow_to_open_how_to_debug/.
# See also: https://blog.askesis.pl/post/2017/04/how-to-debug-zsh-startup-time.html
# zmodload zsh/zprof

# Zsh doesn't store command history unless told to do so. Source:
# https://unix.stackexchange.com/a/470707
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
# Add command to history immediately after execution, as opposed to when the
# session is closed.
setopt SHARE_HISTORY

# Homebrew paths
if [[ -f /opt/homebrew/bin/brew ]]; then
    # The following is a result of running `eval "$(/opt/homebrew/bin/brew shellenv)"`
    export HOMEBREW_PREFIX="/opt/homebrew"
    export HOMEBREW_CELLAR="/opt/homebrew/Cellar"
    export HOMEBREW_REPOSITORY="/opt/homebrew"
    fpath[1,0]="/opt/homebrew/share/zsh/site-functions"
    export PATH="/opt/homebrew/bin:$PATH"
    [ -z "${MANPATH-}" ] || export MANPATH=":${MANPATH#:}"
    export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}"

    # Manually add Java to PATH. Otherwise we wouldn't have access to JVM.
    export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
fi

# Local paths
export PATH="$HOME/.local/bin:$HOME/.local/share/aj-eget-bins:$PATH"

# zsh config lazy loader. Provides the 'lazyload' cmd. Helps speeding up the terminal.
CUSTOM_APPS="$HOME/.local/share/aj-apps"
. "$CUSTOM_APPS/zsh-lazyload/zsh-lazyload.zsh"

# direnv
[ -x "$(command -v direnv)" ] && eval "$(direnv hook zsh)"

# node
export PATH="$HOME/.nodenv/bin:$PATH"

# if this starts making terminals slow I can move it away to be lazy-loaded
# [ -x "$(command -v nodenv)" ] && eval "$(nodenv init - zsh)"
lazyload nodenv -- 'eval "$(nodenv init - zsh)"'
lazyload npm -- 'eval "$(nodenv init - zsh)"'
lazyload node -- 'eval "$(nodenv init - zsh)"'
lazyload mmdc -- 'eval "$(nodenv init - zsh)"'

# Workaround for LS clients not working with lazyload but needing the server binary.
export PATH="$HOME/.nodenv/shims:${PATH}"

# Rust
export RUSTUP_HOME"=$HOME/.local/share/rustup"
export CARGO_HOME="$HOME/.local/share/cargo"
export PATH="$HOME/.local/share/cargo/bin:$PATH"

# Go
# Go workspace. Based on https://24ankitw.medium.com/installing-go-lang-on-mac-homebrew-ee11cc7271fb
export GOPATH="$HOME/.local/share/aj-apps/golang"
export PATH="$GOPATH/bin:$PATH"

# Terminal prompt
[ -x "$(command -v starship)" ] && eval "$(starship init zsh)"

# Enable tab completion customization. Used for aliased commands and completion
# autocorrect.
autoload -Uz compinit
compinit

# Enable editing current command in EDITOR.
autoload -z edit-command-line
zle -N edit-command-line
bindkey "^X^E" edit-command-line

# Make 'cd' match case-insensitive.
# Src: https://superuser.com/a/1092328
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'

# Configure aliases
. ~/.bash_aliases

# Fix deleting one path component at a time.
# Source: https://stackoverflow.com/a/1438523
autoload -U select-word-style
select-word-style bash

export EDITOR="nvim"
# Setting nvim or vim as the EDITOR additionally triggers some zsh magic which changes shell input mode from "emacs
# mode" to "vim mode". This only surfaces when booting zellij, for some weird reason. I like "emacs mode" for word
# navigation, so I need to override this magic. See also:
# https://apple.stackexchange.com/questions/476813/how-to-tell-iterm2-to-use-emacs-mode-not-vi-mode
bindkey -e

# https://github.com/alexjuda/fini
export FINI_DIR="~/Documents/fini-todos"

# Enable kubectl command completions. Lazyloaded to gain 30ms shell startup time on normal boxes.
lazyload kubectl -- 'source <(kubectl completion zsh)'

# Set up zoxide, cd replacement.
eval "$(zoxide init zsh)"

# Activate nix
if [ -e $HOME/.nix-profile/etc/profile.d/nix.sh ]; then . $HOME/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer

# Custom utils
# TODO: move to autoloaded files
function venv-reset-py() {
    local venv_path=".venv"
    [[ -s $venv_path ]] && echo "removing $venv_path..." && rm -r $venv_path
    echo "creating new venv at $venv_path..."
    python3 -m venv $venv_path
    source "${venv_path}/bin/activate"
    pip install --upgrade pip wheel
}

function venv-reset() {
    local venv_path=".venv"
    [[ -s $venv_path ]] && echo "removing $venv_path..." && rm -r $venv_path
    echo "creating new venv at $venv_path..."
    uv venv $venv_path
    source "${venv_path}/bin/activate"
    uv pip install --upgrade pip wheel
}

# sets jira ticket that can later be retrieved by echo $T
function set-ticket() {
    local ticket="$1"
    echo ${ticket} > ~/.local/share/ticket.txt
    T=$(cat ~/.local/share/ticket.txt)
}

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

# Extracting tars is super cumbersome.
# Source: https://askubuntu.com/a/792063
function untar() {
    local filename="$1"
    local basename="${filename%.tar.gz}"

    mkdir -p $basename
    tar -xzf $filename -C $basename
}

# Make a new 'zk' note. Usage:
# 1. cdn
# 2. zkn Hello there!
function zkn() {
    zk new -t "$*"
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

# Uncomment to print startup time profile.
# zprof
