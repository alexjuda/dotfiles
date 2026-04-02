#!/usr/bin/env bash
# Starts the Slack MCP server locally, injecting creds from 1passwords. Workaround for storing credentials in plain text
# files. Used by `opencode-bedrock.json`. This file should be symlinked under `~/.config/opencode/`.
set -euo pipefail

export SLACK_BOT_TOKEN="$(op read 'op://Employee/OpenCode Reader Personal/User OAuth Token')"
export SLACK_TEAM_ID="$(op read 'op://Employee/OpenCode Reader Personal/Lila Slack Team ID')"

exec npx -y @modelcontextprotocol/server-slack
