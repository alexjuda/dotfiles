# Note on .zshrc, .zprofile, .zshenv: https://ss64.com/osx/syntax-profile.html.
# tl;dr we need .zshrc.
# * .zprofile is for SSH connection details only
# * .zshenv is for all shells, including non-interactive ones

# Terminal prompt
# Based on https://sureshjoshi.com/development/zsh-prompts-that-dont-suck
PROMPT='%(?.%F{blue}⏺.%F{red}⏺)%f %2~ '
RPROMPT='%F{8}⏱ %*%f'

# Homebrew paths
if [[ -f /opt/homebrew/bin/brew ]]; then 
    eval "$(/opt/homebrew/bin/brew shellenv)"
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

# Enable tab completion customization. Used for aliased commands and completion
# autocorrect.
autoload -Uz compinit
compinit

# Make 'cd' match case-insensitive.
# Src: https://superuser.com/a/1092328
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'

# Configure aliases
. ~/.bash_aliases

export EDITOR="nvim"

# Pyenv
lazyload pyenv -- '. $CUSTOM_APPS/pyenv.sh'
