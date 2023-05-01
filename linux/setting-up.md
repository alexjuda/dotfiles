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

## 5. Use installer

Most of the remaining set-up is automated via the installer script.

```bash
python3 scripts/installer.py
```
