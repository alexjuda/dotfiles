-- Daily notes & todo lists. As light as water vapor.
local module = {}

-- Usage
-- Call vapor.setup() in your init.vim:
-- lua require('vapor').setup()
--
-- Configuring
-- Pass options to the setup function.
-- lua require('vapor').setup{daily_notes_dir = "~/Documents/notes-synced/daily"}
--
-- Supported config options:
-- - daily_notes_dir (string) - directory where the daily notes should be created. Default: '~/vapor-notes/daily'

-- src: http://lua-users.org/wiki/CopyTable
local function deep_copy_table(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deep_copy_table(orig_key)] = deep_copy_table(orig_value)
        end
        setmetatable(copy, deep_copy_table(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

local function merge_and_mutate_tables(t1, t2)
    for k, v in pairs(t2) do
        if (type(v) == "table") and (type(t1[k] or false) == "table") then
            merge_tables(t1[k], t2[k])
        else
            t1[k] = v
        end
    end
    return t1
end

local function merge_tables(t1, t2)
    local t1_copy = deep_copy_table(t1)
    merge_and_mutate_tables(t1_copy, t2)
    return t1_copy
end

local function daily_file_name(timestamp)
    return os.date("%Y/%Y-%m-%d", timestamp)
end

local function make_scratch_path()
    return vim.g.vapor.scratch_dir .. "/" .. daily_file_name(os.time()) .. '.md'
end

local function make_todo_path()
    return vim.g.vapor.todo_dir .. "/" .. daily_file_name(os.time()) .. '.md'
end

local function edit_file(path)
    vim.api.nvim_exec("edit " .. path, false)
end

-- public

function module.open_scratch()
    edit_file(make_scratch_path())
end

function module.open_todo()
    edit_file(make_todo_path())
end

local default_settings = {
    scratch_dir = "~/vapor-notes/scratch";
    todo_dir = "~/vapor-notes/todo";
}

function module.setup(settings)
    local merged = merge_tables(default_settings, settings or {})
    vim.g.vapor = merged
end

return module
