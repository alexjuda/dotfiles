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

# Pyenv
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
