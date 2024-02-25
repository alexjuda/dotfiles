# Configuring with Ansible

This tool uses Ansible to configure a new device from a host device over SSH.

## Pre-requisites

Steps to take manually before:

1. On the target:
    1. Create an ssh key on the target: `ssh-keygen -t ed25519 -a 100`
    2. Copy the public key into the public folder.
    3. Set a sensible machine name in Gnome Settings.
    4. Enable SSH.
    5. Enable file sharing.
    6. Reboot.

2. On the host:
    1. Upload the target's to GitHub.
    2. Run `ssh-copy-id` between the host and the target.
    3. Install Ansible, e.g. with `pipx`.
    4. Set up `vars.yml` file based on the [example](./vars.yml.example).

3. On the target:
    1. Warm up GitHub with: `ssh -T git@github.com`.

## Running

Find a suitable [maketarget](./Makefile) and run:

```bash
make framework HOST="frmwrk.local"
```

## Post

Steps to run manually after on the guest:

1. Set up 1Password.
2. Open neovim. Run: `:PaqSync`
3. Fix telescope repo.
4. Log in to:
    1. Firefox.
    2. "Internet Accounts" in Gnome Settings.
    3. Spotify.
    4. Signal.
