###########
my dotfiles
###########

A single repo with config files that can be symlinked into their intended locations required by other tools.

************
Installation
************

.. code-block:: sh

    ln -s $PWD/.config/wezterm ~/.config/wezterm
    ln -s $PWD/.config/nvim ~/.config/nvim
    ln -s $PWD/vendor/complete_alias ~/.local/share/complete_alias
    ln -s $PWD/linux/.bash_aliases ~/.bash_aliases
    ln -s $PWD/linux/.bashrc ~/.bashrc
    ln -s $PWD/scripts/git-fetch-repos ~/.local/bin/

    # TODO see if this is still needed
    ln -s $PWD/linux/completions ~/.bash-completions


**********
Misc setup
**********

On macOS:

.. code-block:: sh

    brew install bash-completion@2


On linux:

.. code-block:: sh

    dconf load /org/gnome/shell/extensions/gtile/ < linux/gtile.dconf
    dconf dump /org/gnome/shell/extensions/gtile/ > linux/gtile.dconf


Workaround terminal issues:

.. code-block:: sh

   tic -x vendor/tmux-256color.ti
   bash vendor/test-24-bit-color.sh


neovim
======

paq
---

https://github.com/savq/paq-nvim/

.. code-block:: sh

    git clone --depth=1 https://github.com/savq/paq-nvim.git \
        "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/pack/paqs/start/paq-nvim

fonts
-----

`nvim-bufferline.lua` requires using a font patched with devicon glyphs. 
Get it from the `release page <https://github.com/ryanoasis/nerd-fonts/releases>`_ or the `webpage <https://www.nerdfonts.com/font-downloads>`_.


On macOS:

         brew tap homebrew/cask-fonts
         brew install --cask font-JetBrains-Mono-nerd-font
         brew install --cask font-roboto-mono-nerd-font
         # or whatever else font you need

tree-sitter
-----------

By default tree sitter comes with only C installed.

Run:

.. code-block:: viml

   :TSModuleInfo
   :TSInstall python
   :TSModuleInfo

xclip
-----

Fixes clipboard support on linux.
More details `here <https://vi.stackexchange.com/a/96>`_.

.. code-block:: sh

   sudo apt install xclip

CLI usage (`docs <https://opensource.com/article/19/7/xclip>`_)::
    
    echo "foo" | xclip -sel clip


pyenv
====

`Instructions <https://github.com/pyenv/pyenv#basic-github-checkout>`_

.. code-block:: sh

    git clone https://github.com/pyenv/pyenv.git ~/.pyenv
    cd ~/.pyenv && src/configure && make -C src
    git clone https://github.com/pyenv/pyenv-virtualenv.git $(pyenv root)/plugins/pyenv-virtualenv


Then, install `build dependencies <https://github.com/pyenv/pyenv/wiki#suggested-build-environment>`_.

Finally, set a global python version to be independent from system Python shenanigans.

.. code-block:: sh

    pyenv install --list
    pyenv install 3.10.1
    pyenv global 3.10.1


pipx
====

The only python package that needs to be installed globally

.. code-block:: sh
    
    pip install --user pipx


LSP
===

Python
------


.. code-block:: sh

    pipx install 'python-lsp-server[flake8,mccabe,rope]'
    pipx inject python-lsp-server python-lsp-black
    pipx inject python-lsp-server pylsp-rope


Python 2
--------

.. code-block:: sh

    npm install -g pyright



JavaScript
----------

Don't worry about the "-g" flag, npm handles dependency isolation between libraries.


.. code-block:: sh

   npm install -g typescript typescript-language-server


JSON
----

Don't worry about the "-g" flag, npm handles dependency isolation between libraries.


.. code-block:: sh

    npm install -g vscode-langservers-extracted

Lua
---

Download prebuilt LSP from `releases page <https://github.com/sumneko/lua-language-server/releases>_` and put it under `~/.local/share/aj-lsp/lua-language-server`::

    mkdir -p ~/.local/share/aj-lsp
    mv ~/Downloads/lua-language-server ~/.local/share/aj-lsp/

See also the guide at <https://jdhao.github.io/2021/08/12/nvim_sumneko_lua_conf/#build>.

ltex-ls
-------

`brew install ltex-ls` or:

1. Grab a release from https://github.com/valentjn/ltex-ls/releases
2. Put the exec on your $PATH.

Updating the completions
========================


.. code-block:: sh

    curl https://raw.githubusercontent.com/cykerway/complete-alias/master/complete_alias \
        -o vendor/complete_alias
