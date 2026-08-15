# My Neovim Config

Requires nvim v0.11+. Config layout is mostly influenced by `lazy.nvim` conventions.

## Lua Types

Two styles for luaLS type hints:

**Inline table type** — for one-off params, no extra declarations needed:

```lua
--- @param opts {absolute?: boolean, use_range?: boolean} | nil
local yank_file_path = function(opts)
```

**Named class** — when the same params struct is reused across multiple functions:

```lua
--- @class FileOpts
--- @field absolute? boolean
--- @field use_range? boolean

--- @param params FileOpts | nil
local yank_file_path = function(params)
```

Use inline table types for local/ad-hoc params; use named classes when sharing the type across multiple functions.

Test type hints from the terminal with:

```bash
lua-language-server --check config/nvim | grep <lua file path>
```
