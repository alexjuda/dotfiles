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
    ln -s $PWD/linux/.zshrc ~/.zshrc


neovim
======

paq
---

https://github.com/savq/paq-nvim/

.. code-block:: sh
    git clone https://github.com/savq/paq-nvim.git \
        "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/pack/paqs/opt/paq-nvim
