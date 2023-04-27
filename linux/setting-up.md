# Setting Up

1. Install from Gnome Software
    1. NVIDIA drivers
    2. kitty

2. Linking configs 

```bash
ln -s $PWD/config/kitty ~/.config/kitty
ln -s $PWD/config/nvim ~/.config/nvim
ln -s $PWD/vendor/complete_alias ~/.local/share/complete_alias
ln -s $PWD/linux/.bash_aliases ~/.bash_aliases
ln -s $PWD/linux/.bashrc ~/.bashrc
mkdir ~/.local/bin
ln -s $PWD/scripts/git-fetch-repos ~/.local/bin/
```

3. Neovim 

```bash
sudo dnf install neovim
sudo dnf install gcc-c++
git clone --depth=1 https://github.com/savq/paq-nvim.git "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/pack/paqs/start/paq-nvim
mkdir -p ~/.local/share/lang-servers/ltex-ls-data
touch ~/.local/share/lang-servers/ltex-ls-data/dict.txt
nvim -c ":PaqSync"
```
