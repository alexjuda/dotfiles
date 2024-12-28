# Configuring with Ansible

This tool uses Ansible to configure a new device (target) from a controller device (something you already have under control) over SSH.

## Pre-requisites

Steps to take manually before:

1. On the target:
    1. Create an ssh key on the target: `ssh-keygen -t ed25519 -a 100`
    2. Copy the public key into the public folder.
    3. Set a sensible machine name in Gnome Settings.
    4. Enable SSH.
    5. Enable file sharing.
    6. Install `sudo dnf install python-libdnf5`.
        * Required on Fedora 41+. [More info](https://github.com/ansible/ansible/issues/84206).
    7. Reboot.

2. On the controller:
    1. Upload the target public key's to GitHub.
    2. Run `ssh-copy-id` from the controller to the target.
    3. Install Ansible, e.g. with `pipx`.
    4. Set up `vars.yml` file based on the [example](./vars.yml.example).

3. On the target:
    1. Warm up GitHub with: `ssh -T git@github.com`.

## Running

Find a suitable [maketarget](./Makefile) and run the following. Note that "HOST" denotes an Ansible host, the target device.

```bash
make framework HOST="frmwrk.local"
```

## Post

Steps to run manually on the target:

1. Open neovim. Run: `:PaqSync`
2. Fix telescope repo.
3. Log in to:
    1. 1Password app.
    2. Firefox.
    3. "Internet Accounts" in Gnome Settings.
    4. `gh auth login`
    5. Spotify.
    6. Signal.
