# Setting Up

## 1. Gnome Software

1. NVIDIA drivers
2. kitty

## 2. ghrel

1. Download `ghrel` from https://github.com/jreisinger/ghrel/releases.
2. Unzip it under `~/.local/share/aj-apps/`.
3. `mkdir ~/.local/bin && ln -s $PWD/ghrel ~/.local/bin/`.

## 3. Use installer

Most of the remaining set-up is automated via the installer script.

```bash
python3 scripts/installer.py
```
