# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

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
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
# alias la='ls -A'
alias la='ls -a'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

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

# added by nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# set prompt
PS1='\[\033[01;34m\]\w\[\033[00m\] \$ '

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"


# fix brew/pyenv stuff on macOS.
# src: https://github.com/pyenv/pyenv#homebrew-in-macos
if [ -x "$(command -v brew)" ]; then
    alias brew='env PATH="${PATH//$(pyenv root)\/shims:/}" brew'
fi


# make `cd` completions case insensitive
bind 'set completion-ignore-case on'

# set current jira ticket id
[[ -s ~/.local/share/ticket.txt ]] && T=$(cat ~/.local/share/ticket.txt)

# Share command history between shells
# src: https://superuser.com/a/602405
export PROMPT_COMMAND='history -a'

# Set up direnv
if [ -x "$(command -v direnv)" ]; then
    eval "$(direnv hook bash)"
fi

# ------ custom utils ------

function pyenv-reset() {
    pyenv virtualenv-delete $(basename $PWD)
    [[ -s .python-version ]] && rm .python-version
    pyenv virtualenv $(basename $PWD)
    pyenv local $(basename $PWD)
    pip install --upgrade pip
}

# short for "python virtualenv name"
function pn() {
    pyenv version-name
}

# TODO: fix home path
#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
# export SDKMAN_DIR="/home/alex/.sdkman"
# [[ -s "/home/alex/.sdkman/bin/sdkman-init.sh" ]] && source "/home/alex/.sdkman/bin/sdkman-init.sh"

