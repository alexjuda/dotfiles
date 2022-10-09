local wk = require("which-key")
local telescope = require("telescope.builtin")

local map = function(mode, key, cmd, opts, doc)
    vim.keymap.set(mode, key, cmd, opts)

    if doc then
        wk.register({ [key] = doc })
    end
end

local bufmap = vim.api.nvim_buf_set_keymap
local opts = { noremap = true }

-- Rebinds
----------
-- Rebind § to ` for compatibility with Linux.
vim.api.nvim_set_keymap("i", "§", "`", opts)

-- Global
----------
map("n", "<space><space>", function() telescope.commands() end, opts, "commands")

map("n", "[d", ":lua vim.diagnostic.goto_prev()<CR>", opts)
map("n", "]d", ":lua vim.diagnostic.goto_next()<CR>", opts)

map("v", "*", '"sy:lua vim.api.nvim_command("/" .. vim.fn.getreg("s"))<CR>', opts) -- search for selected text

-- Leaders
------------
vim.g.mapleader = " " -- space as the leader key
vim.g.maplocalleader = "," -- comma as the local leader key


-- Buffers
------------
map("n", "<leader>bb", function() telescope.buffers() end, opts, "buffers")
map("n", "<leader>bp", ":bprev<cr>", opts)
map("n", "<leader>bn", ":bnext<cr>", opts)
map("n", "<leader>bd", ":bp|bd #<cr>", opts) -- close a buffer, but not a window
map("n", "<leader>bD", ":%bd|e#|bd#<cr>", opts)
map("n", "<leader><TAB>", "<C-^>", opts) -- switch to last buffer
map("n", "<C-PageUp>", ":bprev<cr>", opts) -- linux-like prev tab
map("n", "<C-PageDown>", ":bnext<cr>", opts) -- linux-like next tab


-- Tabs
------------
map("n", "<leader>tt", ":tabs<cr>", opts) -- list all tabs
map("n", "<leader>tc", ":tabnew<cr>", opts)
map("n", "<leader>tn", ":tabNext<cr>", opts) -- aka `gt`
map("n", "<leader>tp", ":tabprevious<cr>", opts) -- aka `gT`
map("n", "<leader>td", ":tabclose<cr>", opts)
map("n", "<leader>tD", ":tabonly<cr>", opts) -- kill all except current tab

-- Project
------------
map("n", "<leader>pt", ":NvimTreeToggle<CR>", opts) -- open project tree
map("n", "<leader>po", ":NvimTreeFindFile<CR>", opts) -- reveal current file in project
-- map("n", "<leader>pf", ":GitFiles<CR>", opts) -- find in git-recognized files
map("n", "<leader>pf", function() telescope.find_files() end, opts, "find files")

-- Search
-----------
map("n", "<leader>sb", function() telescope.current_buffer_fuzzy_find() end, opts, "search in buffer")
map("n", "<leader>ss", function() telescope.live_grep() end, opts, "search in PWD")

-- Files
----------
map("n", "<leader>ft", ":NerdTreeToggle<CR>", opts) -- open files tree
map("n", "<leader>fr", function() telescope.oldfiles() end, opts, "recent files")
map("n", "<leader>fc", ":e ~/.config/nvim/init.lua<CR>", opts)
map("n", "<leader>ff", function() telescope.find_files() end, opts, "find files")


-- Triggers
-------------
map("n", "<leader>Tn", ":set number!<CR>", opts)
map("n", "<leader>TU", ":TrainUpDown<CR>", opts) -- Motion training for up/down
map("n", "<leader>TW", ":TrainWord<CR>", opts) -- Motion training for words
map("n", "<leader>TT", ":TrainTextObj<CR>", opts) -- Motion training for text objects


-- Notes
----------
map("n", "<leader>nd", ":lua require('vapor').open_scratch()<CR>", opts)
map("n", "<leader>ns", ":lua require('vapor').open_scratch()<CR>", opts)
map("n", "<leader>nt", ":lua require('vapor').open_todo()<CR>", opts)

-- Editor
-----------
map("n", "<leader>eu", ":UnicodeSearch! ", opts)
map("n", "<leader>ev", ":lua aj_toggle_venn()<CR>", opts)


-- Git--
--------

-- Gitsigns
-- src: https://github.com/lewis6991/gitsigns.nvim#keymaps
----------------------------------------------------------
local gs = package.loaded.gitsigns

-- Actions
map({ 'n', 'v' }, '<leader>gs', ':Gitsigns stage_hunk<CR>', opts, "stage hunk")
map('n', '<leader>gS', gs.stage_buffer, opts, "stage buffer")
map('n', '<leader>gu', gs.undo_stage_hunk, opts, "undo stage hunk")
map('n', '<leader>gR', gs.reset_buffer, opts, "reset buffer")
map('n', '<leader>gp', gs.preview_hunk, opts, "preview hunk")
map('n', '<leader>gb', function() gs.blame_line { full = true } end, opts, "blame line")
map('n', '<leader>tb', gs.toggle_current_line_blame, opts, "toggle current line blame")
map('n', '<leader>gd', gs.diffthis, opts, "diff this")
map('n', '<leader>gD', function() gs.diffthis('~') end, opts, "diff tilde (?)")
map('n', '<leader>td', gs.toggle_deleted, opts, "toggle deleted")

-- Navigation
map('n', ']g', function()
    if vim.wo.diff then return ']c' end
    vim.schedule(function() gs.next_hunk() end)
    return '<Ignore>'
end, { expr = true })

map('n', '[g', function()
    if vim.wo.diff then return '[c' end
    vim.schedule(function() gs.prev_hunk() end)
    return '<Ignore>'
end, { expr = true })

-- Text object
map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')

-- openingh
map("n", "<Leader>gr", ":OpenInGHRepo <CR>", opts)
map("n", "<Leader>gf", ":OpenInGHFile <CR>", opts)

-- Root
---------
map("n", "<leader><esc>", ":nohlsearch<cr>", opts)


-- Local leader
-----------------

-- venn --
-- enable or disable keymappings for venn
function _G.aj_toggle_venn()
    local venn_enabled = vim.inspect(vim.b.venn_enabled)
    if (venn_enabled == "nil") then
        vim.b.venn_enabled = true
        vim.cmd [[setlocal ve=all]]
        -- draw a line on HJKL keystokes
        bufmap(0, "n", "J", "<C-v>j:VBox<cr>", opts)
        bufmap(0, "n", "K", "<C-v>k:VBox<cr>", opts)
        bufmap(0, "n", "L", "<C-v>l:VBox<cr>", opts)
        bufmap(0, "n", "H", "<C-v>h:VBox<cr>", opts)
        -- draw a box by pressing "f" with visual selection
        bufmap(0, "v", "f", ":VBox<cr>", opts)
    else
        vim.cmd [[setlocal ve=]]
        vim.cmd [[mapclear <buffer>]]
        vim.b.venn_enabled = nil
    end
end

map("n", "<localleader>v", ":lua aj_toggle_venn()<CR>", opts)

-- markdown --
-- paste as markdown link
function _G.aj_paste_markdown_link()
    local url = vim.fn.getreg("*")
    local formatted = "()[" .. url .. "]"

    -- taken from https://www.reddit.com/r/neovim/comments/psux8f/comment/hdsfi9s/?utm_source=share&utm_medium=web2x&context=3
    local pos = vim.api.nvim_win_get_cursor(0)[2]
    local line = vim.api.nvim_get_current_line()
    local new_line = line:sub(0, pos + 1) .. formatted .. line:sub(pos + 2)
    vim.api.nvim_set_current_line(new_line)
end

-- TODO: set this only when entering markdown files
map("n", "<localleader>p", ":lua aj_paste_markdown_link()<CR>", opts)


-- LSP local leaders --
-- We gotta do it here, because buf-local mappings don't seem to work properly in visual mode :(.
vim.api.nvim_set_keymap("v", "<localleader>la", ":lua vim.lsp.buf.range_code_action()<CR>", opts)

-- Show info about currently active LSP connections
vim.api.nvim_set_keymap("n", "<localleader>Li", ":LspInfo<CR>", opts)

-- Kill LSP clients
vim.api.nvim_set_keymap("n", "<localleader>Ld", ":lua vim.lsp.stop_client(vim.lsp.get_active_clients())<CR>", opts)
