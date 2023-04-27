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

4. Python

Src:
* https://github.com/pyenv/pyenv#installation
* https://stribny.name/blog/install-python-dev/

```bash
git clone https://github.com/pyenv/pyenv.git ~/.pyenv
# Compile dynamic bash extension
cd ~/.pyenv && src/configure && make -C src

sudo dnf install zlib-devel bzip2 bzip2-devel readline-devel sqlite sqlite-devel openssl-devel xz xz-devel libffi-devel findutils
pyenv install ...
pyenv global ...
```
