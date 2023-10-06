# Homebrew paths
eval "$(/opt/homebrew/bin/brew shellenv)"

# Local paths
export PATH="/Users/alex/.local/bin:$PATH"

CUSTOM_APPS="/Users/alex/.local/share/aj-apps"

# zsh config lazy loader. Helps speeding up the terminal.
. "$CUSTOM_APPS/zsh-lazyload/zsh-lazyload.zsh"

# Node Version Manager
export NVM_DIR="$HOME/.nvm"
lazyload nvm -- '. "$NVM_DIR/nvm.sh"'
lazyload node -- '. "$NVM_DIR/nvm.sh"'

# Enable tab completion for aliased commands
autoload -Uz compinit
compinit

# Configure aliases
. ~/.bash_aliases

export EDITOR="nvim"

# Pyenv
lazyload pyenv -- '. $CUSTOM_APPS/pyenv.sh'
