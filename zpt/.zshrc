# pyenv
export PATH="/Users/alex/.pyenv/bin:$PATH"
eval "$(pyenv init - --no-rehash)"
eval "$(pyenv virtualenv-init -)"

# pypoetry
export PATH="$HOME/.poetry/bin:$PATH"

# Created by `userpath` on 2021-02-02 12:03:34
export PATH="$PATH:/Users/alex/.local/bin"

# use homebrew's openblas
export LDFLAGS="-L/usr/local/opt/openblas/lib $LDFLAGS"
export CPPFLAGS="-I/usr/local/opt/openblas/include $CPPFLAGS"
export PKG_CONFIG_PATH="/usr/local/opt/openblas/lib/pkgconfig:$PKG_CONFIG_PATH"
export OPENBLAS="/usr/local/opt/openblas"

# use homebrew's lapack
export LDFLAGS="-L/usr/local/opt/lapack/lib $LDFLAGS"
export CPPFLAGS="-I/usr/local/opt/lapack/include $CPPFLAGS"
export PKG_CONFIG_PATH="/usr/local/opt/lapack/lib/pkgconfig:$PKG_CONFIG_PATH"

