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

# Node Version Manager
export NVM_DIR="$HOME/.nvm"
lazyload nvm -- '. "$NVM_DIR/nvm.sh"'
lazyload node -- '. "$NVM_DIR/nvm.sh"'
lazyload npm -- '. "$NVM_DIR/nvm.sh"'

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

# Pyenv
lazyload pyenv -- '. $CUSTOM_APPS/pyenv.sh'

# Custom utils
# TODO: move to autoloaded files
function venv-reset() {
    local venv_path="./venv"
    [[ -s $venv_path ]] && echo "removing $venv_path..." && rm -r $venv_path
    echo "creating new venv at $venv_path..."
    python3 -m venv $venv_path
    source "${venv_path}/bin/activate"
    pip install --upgrade pip wheel
}

# sets jira ticket that can later be retrieved by echo $T
function set-ticket() {
    local ticket="$1"
    echo ${ticket} > ~/.local/share/ticket.txt
    T=$(cat ~/.local/share/ticket.txt)
}
