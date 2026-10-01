# Ansible Configuration

## Overview

Ansible playbooks for managing Fedora workstations.

## Quick Start

```bash
cd /home/alex/Code/dotfiles/linux/ansible
make localhost
```

This runs ansible as root via sudo, which triggers your fingerprint (or password) once.

## Files

- `ansible.cfg` - Ansible configuration
- `Makefile` - Build targets for common operations
- `playbooks/` - Individual playbooks for different system components
- `vars.yml` - Variables (should contain git_email, git_username, etc.)
- `templates/` - Templates for fresh machine setup (not currently used)

## Fresh Machine Setup

No special setup required - just run `make localhost` and authenticate with your fingerprint once.

## Adding CLI tools

Prefer the lowest-friction package manager first:

1. Fedora DNF → `system-tools.yml` (if available in repos)
2. COPR → enable copr repo + `dnf` in `system-tools.yml` (if available but not in main repos)
3. Language-specific installation tool - `python.yml`, `node.yml`, etc
4. eget via GitHub releases → `gh-releases.yml`

## Adding config files

When a new app has a config file: create `../../config/<app>/` with the minimal config, then add a symlink task to `playbooks/link-configs.yml`.
