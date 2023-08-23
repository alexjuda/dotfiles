# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# --- profiling ---
# Source: https://stackoverflow.com/a/5015179
# PS4='+ $(gdate "+%s.%N")\011 '
# exec 3>&2 2>/tmp/bashstart.$$.log
# set -x
# --- /profiling ---

# Suppress zsh warning.
# Source: https://support.apple.com/en-us/HT208050
export BASH_SILENCE_DEPRECATION_WARNING=1

# --------- ubuntu default config ---------

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
# HISTSIZE=1000
# HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar


# Change dirs with pure paths without the 'cd' command.
shopt -s autocd

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# ------------------------------------------------------
# manual setup


# set alias for xdg-open on linux
if ! [ -x "$(command -v open)" ]; then
    alias open=xdg-open
fi

# bash completion on macOS
# requires "brew install bash-completion@2"
[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"

NIX_PROFILE="$HOME/.nix-profile"

# setup wrapper for bash completions
[[ -s "$HOME/.local/share/complete_alias" ]] && . "$HOME/.local/share/complete_alias"

# added by pipx (https://github.com/pipxproject/pipx)
export PATH="$HOME/.local/bin:$PATH"

# set prompt
PS1='\[\033[01;34m\]\w\[\033[00m\] \$ '

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# fix brew/pyenv stuff on macOS. Without this, brew formulas that depend on
# Python would link against pyenv-provided global Python.
# src: https://github.com/pyenv/pyenv#homebrew-in-macos
if [ -x "$(command -v brew)" ]; then
    alias brew='env PATH="${PATH//$(pyenv root)\/shims:/}" brew'
fi

# make `cd` completions case insensitive
bind 'set completion-ignore-case on'

# set current jira ticket id
[[ -s ~/.local/share/ticket.txt ]] && T=$(cat ~/.local/share/ticket.txt)

# Edit commit messages in nvim
export EDITOR="nvim"

# node
# Use custom prefix for global packages to workaround sudo installation under
# Fedora. Source:
# https://danillolima.com/en/npm/how-to-fix-permissions-on-globally-installing-npm-packages-on-linux/
export PATH="~/.npm-global/bin:$PATH"


# src: https://stackoverflow.com/a/19533853
# Eternal bash history.
# ---------------------
# Undocumented feature which sets the size to "unlimited".
# http://stackoverflow.com/questions/9457233/unlimited-bash-history
export HISTFILESIZE=
export HISTSIZE=
export HISTTIMEFORMAT="[%F %T] "
# Change the file location because certain bash sessions truncate .bash_history file upon close.
# http://superuser.com/questions/575479/bash-history-truncated-to-500-lines-on-each-login
export HISTFILE=~/.bash_eternal_history
# Force prompt to write history after every command.
# http://superuser.com/questions/20900/bash-history-loss
PROMPT_COMMAND="history -a; $PROMPT_COMMAND"

# ------ custom utils ------

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

# tool for finding common ancenstor of two branches. I never remember the
# correct git command name.
function git-common-ancestor() {
    git merge-base "$1" "$2"
}

# Load cargo if loader exists
[ -s "$HOME/.cargo/env" ] && \. "$HOME/.cargo/env"

# Added by nvm
# You can set $NVM_DIR to any location, but leaving it unchanged from
# /usr/local/Cellar/nvm/0.39.5 will destroy any nvm-installed Node
# installations upon upgrade/reinstall.
export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && \. "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

# --- profiling ---
# set +x
# exec 2>&3 3>&-
# --- /profiling ---
