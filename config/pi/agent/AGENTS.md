Always use `jq` for JSON formatting.

The `bd` CLI mangles shell-special characters (backticks, `$()`) in string arguments. Always pass descriptions via temp files: write to `/tmp/desc.txt`, then use `bd create --description "$(cat /tmp/desc.txt)"`. Never use heredocs with `bd` commands.
