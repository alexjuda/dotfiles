###########
my dotfiles
###########

A single repo with config files that can be symlinked into their intended locations required by other tools.

************
Installation
************

.. code-block:: sh

    ln -s $PWD/.config/alacritty ~/.config/alacritty
    ln -s $PWD/.config/nvim ~/.config/nvim
    ln -s $PWD/.tmux.conf ~/.tmux.conf
    ln -s $PWD/vendor/complete_alias ~/.local/share/complete_alias
    ln -s $PWD/linux/.bash_aliases ~/.bash_aliases


On linux:

.. code-block:: sh

    ln -s $PWD/linux/.bashrc ~/.bashrc
    # TODO see if this is still needed
    ln -s $PWD/linux/completions ~/.bash-completions
    ln -s $PWD/linux/.tmux-linux.conf ~/.tmux-linux.conf
    dconf load /org/gnome/shell/extensions/gtile/ < linux/gtile.dconf
    dconf load /org/gnome/settings-daemon/plugins/media-keys/ < linux/media-keys.dconf

On macOS:

.. code-block:: sh

    ln -s $PWD/linux/.bashrc ~/.bash_profile
    ln -s $PWD/macos/.tmux-macos.conf ~/.tmux-macos.conf


**********
Misc setup
**********

On macOS:

.. code-block:: sh

    brew install alacritty
    brew install tmux
    brew install bash-completion@2


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
Get it from the `release page <https://github.com/ryanoasis/nerd-fonts/releases>`_.

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


pipx
====

The only python package that needs to be installed globally

.. code-block:: sh
    
    pip install -u pipx


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


Updating the completions
========================


.. code-block:: sh

    curl https://raw.githubusercontent.com/cykerway/complete-alias/master/complete_alias \
        -o vendor/complete_alias
