# Keeping it in another file helps loading it lazily.
export PYENV_ROOT="$HOME/.local/share/pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
