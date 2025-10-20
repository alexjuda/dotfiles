# My dotfiles

A single repo with all my configs. System tools, shell, code editor, keyboard remaps.

Workstation configuration is deployed with [Ansible](https://www.ansible.com/). See [linux/ansible/Makefile](linux/ansible/Makefile).

Tool configs are kept in [config dir](./config). Every dir is symlinked under `~/.config/` by
Ansible. My [neovim config](./config/nvim/) is the most involved one.
