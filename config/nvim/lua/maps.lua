local wk = require("which-key")
local telescope = require("telescope.builtin")
local vapor = require("vapor")

local map = function(mode, key, cmd, opts, doc)
    vim.keymap.set(mode, key, cmd, opts)

    if doc then
        wk.register({ [key] = doc })
    end
end

local bufmap = vim.api.nvim_buf_set_keymap
local opts = { noremap = true }

-- Shared opts for telescope's finder
local finder_opts = {
    -- Telescope defaults to an rg invocation that ignores hidden files. I
    -- wanna make rg search inside the hidden files/dirs as well (--hidden).
    -- However, I don't wanna include results from the .git folder.
    --
    -- Default call: https://github.com/nvim-telescope/telescope.nvim/blob/b923665e64380e97294af09117e50266c20c71c7/lua/telescope/builtin/__files.lua#L184
    find_command = { "rg", "--files", "--color", "never", "--hidden", "--glob", "!.git" },
}


-- Leaders
------------
vim.g.mapleader = " "      -- space as the leader key
vim.g.maplocalleader = "," -- comma as the local leader key


-- Buffers
------------
map("n", "<leader>bb", function() telescope.buffers() end, opts, "buffers")
map("n", "<leader>bp", ":bprev<cr>", opts)
map("n", "<leader>bn", ":bnext<cr>", opts)
map("n", "<leader>bd", ":bp|bd #<cr>", opts) -- close a buffer, but not a window
map("n", "<leader>bD", ":%bd|e#|bd#<cr>", opts)
map("n", "<leader><TAB>", "<C-^>", opts)     -- switch to last buffer
map("n", "<C-PageUp>", ":bprev<cr>", opts)   -- linux-like prev tab
map("n", "<C-PageDown>", ":bnext<cr>", opts) -- linux-like next tab


-- Project
------------
map("n", "<leader>pt", ":SidebarNvimToggle<CR>", opts) -- open project tree
map("n", "<leader>pf", function() telescope.find_files(finder_opts) end, opts, "find file by name")

-- Search
-----------
map("n", "<leader>sb", function() telescope.current_buffer_fuzzy_find() end, opts, "search in buffer")
map("n", "<leader>ss", function() telescope.live_grep() end, opts, "search in PWD")

-- Files
----------
map("n", "<leader>ft", ":SidebarNvimToggle<CR>", opts) -- open files tree
map("n", "<leader>fr", function() telescope.oldfiles() end, opts, "recent files")
map("n", "<leader>fR", ":SidebarNvimUpdate<CR>", opts) -- reload sidebar's state
map("n", "<leader>fc", ":e ~/.config/nvim/init.lua<CR>", opts)
map("n", "<leader>ff", function() telescope.find_files() end, opts, "find files")


-- Toggles
-------------
map("n", "<leader>tn", ":set number!<CR>", opts)
map("n", "<leader>tU", ":TrainUpDown<CR>", opts)   -- Motion training for up/down
map("n", "<leader>tW", ":TrainWord<CR>", opts)     -- Motion training for words
map("n", "<leader>tT", ":TrainTextObj<CR>", opts)  -- Motion training for text objects
map("n", "<leader>ta", ":AerialToggle!<CR>", opts) -- Toggle aerial sidebar


-- Notes
----------
map("n", "<leader>nd", function() vapor.open_scratch() end, opts, "daily note")
map("n", "<leader>nt", function() vapor.open_todo() end, opts, "daily todo")

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


-- Rebinds
----------
-- Rebind § to ` for compatibility with Linux.
vim.api.nvim_set_keymap("i", "§", "`", opts)

-- Global
----------
map("n", "<space><space>", function() telescope.commands() end, opts, "commands")

map("n", "[d", function() vim.diagnostic.goto_prev() end, opts, "prev diagnostic")
map("n", "]d", function() vim.diagnostic.goto_next() end, opts, "next diagnostic")

map("n", "[a", "<cmd>AerialPrev<CR>", opts, "prev symbol (aerial)")
map("n", "]a", "<cmd>AerialNext<CR>", opts, "next symbol (aerial)")

map("n", "[q", ":cprev<CR>", opts, "prev quickfix")
map("n", "]q", ":cnext<CR>", opts, "next quickfix")

map("v", "*", '"sy:lua vim.api.nvim_command("/" .. vim.fn.getreg("s"))<CR>', opts) -- search for selected text

map("n", "yp", '"0p', opts, "paste last yanked")
map("n", "yP", '"0P', opts, "paste last yanked, prev")

map("n", "s/", ":HopPatternMW<CR>", opts)
map("n", "ss", ":HopChar2MW<CR>", opts)
map("n", "ss", ":HopChar2MW<CR>", opts)

-- Enable standard terminal keybindings in the vim command mode
local readline = require 'readline'
vim.keymap.set('!', '<M-f>', readline.forward_word)
vim.keymap.set('!', '<M-b>', readline.backward_word)
vim.keymap.set('!', '<C-a>', readline.beginning_of_line)
vim.keymap.set('!', '<C-e>', readline.end_of_line)
vim.keymap.set('!', '<M-d>', readline.kill_word)
vim.keymap.set('!', '<M-BS>', readline.backward_kill_word)
vim.keymap.set('!', '<C-w>', readline.unix_word_rubout)
vim.keymap.set('!', '<C-k>', readline.kill_line)
vim.keymap.set('!', '<C-u>', readline.backward_kill_line)


------------------
-- My own utils --
------------------

-- Inserting values at point --
--------------------------------
--
local function insert_text_at_cursor(text)
    -- Based on https://vi.stackexchange.com/a/39684
    local current_win = 0
    local row, col = unpack(vim.api.nvim_win_get_cursor(current_win))
    local text_len = text:len()

    vim.api.nvim_buf_set_text(0, row - 1, col, row - 1, col, { text })
    vim.api.nvim_win_set_cursor(current_win, { row, col + text_len })
end

-- Insert current date anywhere
local function local_date(timestamp)
    return os.date("%Y-%m-%d", timestamp)
end

local function insert_current_date()
    local date = local_date(os.time())
    insert_text_at_cursor(date)
end

vim.keymap.set({ "i", "n" }, "<F3>", insert_current_date)
