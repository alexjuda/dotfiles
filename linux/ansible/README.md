# Configuring with Ansible

This tool uses Ansible to configure a new device from a host device over SSH.

## Pre-requisites

Steps to take manually before:

1. Install Ansible on the host, e.g. with `pipx`.
2. Create an ssh key on the target.
3. Upload the guest's public SSH key to GitHub.
4. Run `ssh-copy-id` between the host and the guest.
5. Set up `vars.yml` file based on the [example](./vars.yml.example).
6. On the guest, set a sensible machine name in Gnome Settings.

## Running

```bash
make no-mac INVENTORY="<machine name>.local,"
```

## Post

Steps to run manually after on the guest:

1. Open neovim. Run: `:PaqSync`
2. Fix telescope repo.
3. Log in to:
    1. Firefox.
    2. "Internet Accounts" in Gnome Settings.
    3. Spotify.
    4. Signal.
