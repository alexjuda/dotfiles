local map = vim.api.nvim_set_keymap
local bufmap = vim.api.nvim_buf_set_keymap
local opts = { noremap = true }

-- Rebinds
----------
-- Rebind § to ` for compatibility with Linux.
vim.api.nvim_set_keymap("i", "§", "`", opts)

-- Global
----------
map("n", "<space><space>", ":Commands<CR>", opts)

map("n", "[d", ":lua vim.lsp.diagnostic.goto_prev()<CR>", opts)
map("n", "]d", ":lua vim.lsp.diagnostic.goto_next()<CR>", opts)

map("v", "*", '"sy:lua vim.api.nvim_command("/" .. vim.fn.getreg("s"))<CR>', opts) -- search for selected text

-- Leaders
------------
vim.g.mapleader = " " -- space as the leader key
vim.g.maplocalleader = "," -- comma as the local leader key


-- Buffers
------------
map("n", "<leader>bb", ":Buffers<cr>", opts)
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
map("n", "<leader>pf", ":GitFiles<CR>", opts) -- find in git-recognized files

-- Search
-----------
map("n", "<leader>ss", ":Rg ", opts) -- search symbol in project

-- Files
----------
map("n", "<leader>ft", ":NerdTreeToggle<CR>", opts) -- open files tree
map("n", "<leader>fr", ":History<CR>", opts) -- recent files
map("n", "<leader>fc", ":e ~/.config/nvim/init.lua<CR>", opts)
map("n", "<leader>ff", ":Files<CR>", opts) -- find in pwd


-- Triggers
-------------
map("n", "<leader>Tn", ":set number!<CR>", opts)
map("n", "<leader>TU", ":TrainUpDown<CR>", opts) -- Motion training for up/down
map("n", "<leader>TW", ":TrainWord<CR>", opts) -- Motion training for words
map("n", "<leader>TT", ":TrainTextObj<CR>", opts) -- Motion training for text objects


-- Notes
----------
map("n", "<leader>nd", ":lua require('vapor').open_daily_note()<CR>", opts)
map("n", "<leader>ni", ":lua require('vapor').open_notes_index()<CR>", opts)
-- TODO: remove nabla because it's broken
map("n", "<leader>nl", ":lua require('nabla').place_inline()<CR>", opts)
map("n", "<F5>", ":lua require('nabla').place_inline()<CR>", opts) -- nabla.vim recommends this

-- Editor
-----------
map("n", "<leader>eu", ":UnicodeSearch! ", opts)
map("n", "<leader>ev", ":lua toggle_venn()<CR>", opts)

-- Root
---------
map("n", "<leader><esc>", ":nohlsearch<cr>", opts)


-- Local leader
-----------------
-- The actual keymap is set in LSP `on_attach` callback in `lua/settings.lua`.

-- enable or disable keymappings for venn
function _G.toggle_venn()
    local venn_enabled = vim.inspect(vim.b.venn_enabled) 
    if(venn_enabled == "nil") then
        vim.b.venn_enabled = true
        vim.cmd[[setlocal ve=all]]
        -- draw a line on HJKL keystokes
        bufmap(0, "n", "J", "<C-v>j:VBox<cr>", opts)
        bufmap(0, "n", "K", "<C-v>k:VBox<cr>", opts)
        bufmap(0, "n", "L", "<C-v>l:VBox<cr>", opts)
        bufmap(0, "n", "H", "<C-v>h:VBox<cr>", opts)
        -- draw a box by pressing "f" with visual selection
        bufmap(0, "v", "f", ":VBox<cr>", opts)
    else
        vim.cmd[[setlocal ve=]]
        vim.cmd[[mapclear <buffer>]]
        vim.b.venn_enabled = nil
    end
end
map("n", "<localleader>v", ":lua toggle_venn()<CR>", opts)

