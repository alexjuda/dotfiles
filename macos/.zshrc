# Note on .zshrc, .zprofile, .zshenv: https://ss64.com/osx/syntax-profile.html.
# tl;dr we need .zshrc.
# * .zprofile is for SSH connection details only
# * .zshenv is for all shells, including non-interactive ones


# Zsh doesn't store command history unless told to do so. Source:
# https://unix.stackexchange.com/a/470707
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
# Add command to history immediately after execution, as opposed to when the
# session is closed.
setopt SHARE_HISTORY

# Terminal prompt
# Based on https://sureshjoshi.com/development/zsh-prompts-that-dont-suck
PROMPT='%(?.%F{blue}⏺.%F{red}⏺)%f %2~ '
RPROMPT='%F{8}⏱ %*%f'

# Homebrew paths
if [[ -f /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
    export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
fi

# Local paths
export PATH="$HOME/.local/bin:$PATH"

# zsh config lazy loader. Helps speeding up the terminal.
CUSTOM_APPS="$HOME/.local/share/aj-apps"
. "$CUSTOM_APPS/zsh-lazyload/zsh-lazyload.zsh"

# direnv
[ -x "$(command -v direnv)" ] && eval "$(direnv hook zsh)"

# rye
# TODO: set up rye in ansible
[ -x "$(command -v rye)" ] && source "$HOME/.local/share/rye_home/env"

# node
export PATH="$HOME/.nodenv/bin:$PATH"
# if this starts making terminals slow I can move it away to be lazy-loaded
[ -x "$(command -v nodenv)" ] && eval "$(nodenv init -)"

# Enable tab completion customization. Used for aliased commands and completion
# autocorrect.
autoload -Uz compinit
compinit

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

# Enable kubectl command completions
[ -x "$(command -v kubectl)" ] && source <(kubectl completion zsh)

# Pyenv
export PATH="$HOME/.pyenv/bin:$PATH"
# Add the following commands as triggers for loading pyenv.
lazyload pyenv -- '. $CUSTOM_APPS/pyenv.sh'
# 'python' and 'python3' also depend on running 'pyenv.sh'. However, binding
# the to run 'pyenv.sh' causes problems, probably due to cyclic dependency
# between pyenv and python.

# Custom utils
# TODO: move to autoloaded files
function venv-reset() {
    local venv_path=".venv"
    [[ -s $venv_path ]] && echo "removing $venv_path..." && rm -r $venv_path
    echo "creating new venv at $venv_path..."
    python3 -m venv $venv_path
    source "${venv_path}/bin/activate"
    pip install --upgrade pip wheel
}

function venv-reset-uv() {
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
