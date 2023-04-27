# Setting Up

## 1. Gnome Software

1. NVIDIA drivers
2. kitty

## 2. Linking configs

```bash
ln -s $PWD/config/kitty ~/.config/kitty
ln -s $PWD/config/nvim ~/.config/nvim
ln -s $PWD/vendor/complete_alias ~/.local/share/complete_alias
ln -s $PWD/linux/.bash_aliases ~/.bash_aliases
ln -s $PWD/linux/.bashrc ~/.bashrc
mkdir ~/.local/bin
ln -s $PWD/scripts/git-fetch-repos ~/.local/bin/
```

## 3. Neovim

```bash
sudo dnf install neovim
sudo dnf install gcc-c++
git clone --depth=1 https://github.com/savq/paq-nvim.git "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/pack/paqs/start/paq-nvim
mkdir -p ~/.local/share/lang-servers/ltex-ls-data
touch ~/.local/share/lang-servers/ltex-ls-data/dict.txt
nvim -c ":PaqSync"
```

## 4. ghrel

1. Download `ghrel` from https://github.com/jreisinger/ghrel/releases.
2. Unzip it under `~/.local/share/aj-apps/`.
3. `mkdir ~/.local/bin && ln -s $PWD/ghrel ~/.local/bin/`.

## 5. Fonts

* src: https://docs.rockylinux.org/books/nvchad/nerd_fonts/

```bash
ghrel -p JetBrainsMono.zip ryanoasis/nerd-fonts
mkdir -p ~/.local/share/fonts/JetBrainsMono
unzip JetBrainsMono.zip -d ~/.local/share/fonts/JetBrainsMono/
```

## 5. System tools

```bash
sudo dnf install fd-find
sudo dnf install ripgrep
```

## 6. Python

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


## 7. Node

* src: https://developer.fedoraproject.org/tech/languages/nodejs/nodejs.html

```bash
sudo dnf install nodejs
mkdir ~/.local/share/npm-global
npm config set prefix ~/.local/share/npm-global
```
