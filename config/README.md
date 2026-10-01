# Dotfile Configs

## Adding configs

When a new app has a config file: create `./<app>/` with the minimal config, then add a symlink task to [../linux/ansible/playbooks/link-configs.yml](../linux/ansible/playbooks/link-configs.yml).

If the app generates runtime files (e.g. `session.json`, `.plugins.lock`), add `./<app>/.gitignore` listing them so they don't pollute git status.
