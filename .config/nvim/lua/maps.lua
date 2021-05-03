local map = vim.api.nvim_set_keymap
local opts = { noremap = true }


-- Leaders
------------
vim.g.mapleader = " " -- space as the leader key
vim.g.maplocalleader = "," -- comma as the local leader key

local which_key_map = {}
local which_key_local_map = {}
vim.fn["which_key#register"]("<Space>", "g:which_key_map")
vim.fn["which_key#register"](",", "g:which_key_local_map")

-- Fire which key on leader/local leader
map("n", "<leader>", ":WhichKey '<space>'<CR>", opts)
map("n", "<localleader>", ":WhichKey ','<CR>", opts)
map("v", "<leader>", ":WhichKeyVisual '<space>'<CR>", opts)
map("v", "<localleader>", ":WhichKeyVisual ','<CR>", opts)

-- Buffers
------------
which_key_map.n = { name = "+buffers" }
map("n", "<leader>bb", ":Buffers<cr>", opts)
map("n", "<leader>bn", ":bnext<cr>", opts)
map("n", "<leader>bp", ":bprev<cr>", opts)
map("n", "<leader>bd", ":bdelete<cr>", opts)
map("n", "<leader><TAB>", "<C-^>", opts) -- switch to last buffer


-- Project
------------
which_key_map.p = { name = "+project" }
map("n", "<leader>pt", ":NERDTreeToggleVCS<CR>", opts) -- open project tree
map("n", "<leader>po", ":NERDTreeFind<CR>", opts) -- reveal current file in project
map("n", "<leader>pf", ":Files<CR>", opts) -- find in pwd


-- Files
----------
which_key_map.f = { name = "+files" }
map("n", "<leader>ft", ":NerdTreeToggle<CR>", opts) -- open files tree
map("n", "<leader>fr", ":History<CR>", opts) -- recent files


-- Triggers
-------------
which_key_map.T = { name = "+triggers" }
map("n", "<leader>Tn", ":set number!<CR>", opts) -- recent files


-- Notes
----------
which_key_map.n = { name = "+notes" }
map("n", "<leader>nd", ":lua require('vapor').open_daily_note()<CR>", opts) -- recent files
map("n", "<leader>ni", ":lua require('vapor').open_notes_index()<CR>", opts) -- recent files


-- Root
---------
map("n", "<leader><esc>", ":nohlsearch<cr>", opts)


-- Local leader
-----------------
which_key_local_map.l = { name = "+lsp" }
-- The actual keymap is set in LSP `on_attach` callback in `lua/settings.lua`.


-- `vim.g` variables can't be modified in place from lua
vim.g.which_key_map = which_key_map
vim.g.which_key_local_map = which_key_local_map

