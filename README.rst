###########
my dotfiles
###########

A single repo with config files that can be symlinked into their intended locations required by other tools.

************
Installation
************

.. code-block:: sh

    ln -s $PWD/.config/alacritty ~/.config/alacritty
    ln -s $PWD/.config/kitty ~/.config/kitty
    ln -s $PWD/.config/nvim ~/.config/nvim
    ln -s $PWD/.tmux.conf ~/.tmux.conf
    ln -s $PWD/vendor/complete_alias ~/.local/share/complete_alias
    ln -s $PWD/linux/.bash_aliases ~/.bash_aliases


On linux:

.. code-block:: sh

    ln -s $PWD/linux/.bashrc ~/.bashrc
    ln -s $PWD/linux/.tmux-linux.conf ~/.tmux-linux.conf
    ln -s $PWD/linux/.Xmodmap ~/.Xmodmap
    ln -s $PWD/linux/remap-keys.desktop ~/.config/autostart/remap-keys.desktop

    # TODO see if this is still needed
    ln -s $PWD/linux/completions ~/.bash-completions

    dconf load /org/gnome/shell/extensions/gtile/ < linux/gtile.dconf
    dconf load /org/gnome/settings-daemon/plugins/media-keys/ < linux/media-keys.dconf
    dconf load /org/gnome/desktop/input-sources/xkb-options/ < linux/xkb-options.dconf

On macOS:

.. code-block:: sh

    ln -s $PWD/linux/.bashrc ~/.bash_profile
    ln -s $PWD/macos/.tmux-macos.conf ~/.tmux-macos.conf


**********
Misc setup
**********

Remap keys on Linux:

.. code-block:: sh

    xmodmap -e "keycode 94 = grave asciitilde" # make key between shift and z work as grave/tilde
    xmodmap -pke # show all keybindings
    xmodmap -pke > linux/.Xmodmap # update keymap


On macOS:

.. code-block:: sh

    brew install alacritty
    brew install tmux
    brew install bash-completion@2


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

    git clone https://github.com/savq/paq-nvim.git \
        "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/pack/paqs/opt/paq-nvim

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


keyboard
========

revert fn behaviour
-------------------

Add the following line to `/etc/modprobe.d/hid_apple.conf`

.. code-block:: sh
    
    options hid_apple fnmode=2


.. code-block:: sh
    
    sudo update-initramfs -u


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

Clone the repo at `~/.local/share/aj-lsp/lua-language-server`::

     git clone git@github.com:sumneko/lua-language-server.git ~/.local/share/aj-lsp/lua-language-server
     cd ~/.local/share/aj-lsp/lua-language-server
     git submodule update --init --recursive

Then, follow the build instructions at
<https://github.com/sumneko/lua-language-server/wiki/Build-and-Run-(Standalone)>.

See also the guide at <https://jdhao.github.io/2021/08/12/nvim_sumneko_lua_conf/#build>.

Updating the completions
========================


.. code-block:: sh

    curl https://raw.githubusercontent.com/cykerway/complete-alias/master/complete_alias \
        -o vendor/complete_alias
