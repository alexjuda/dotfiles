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