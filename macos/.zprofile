# Homebrew paths
eval "$(/opt/homebrew/bin/brew shellenv)"

# Local paths
export PATH="/Users/alex/.local/bin:$PATH"

# Node Version Manager
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Enable tab completion for aliased commands
autoload -Uz compinit
compinit

# Configure aliases
. ~/.bash_aliases

export EDITOR="nvim"
