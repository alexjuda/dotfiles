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
map("n", "<leader>bD", ":NERDTreeClose<bar>bufdo bd<cr>", opts)
map("n", "<leader><TAB>", "<C-^>", opts) -- switch to last buffer


-- Tabs
------------
which_key_map.t = { name = "+tabs" }
map("n", "<leader>tt", ":tabs<cr>", opts) -- list all tabs
map("n", "<leader>tc", ":tabnew<cr>", opts)
map("n", "<leader>tn", ":tabNext<cr>", opts) -- aka `gt`
map("n", "<leader>tp", ":tabprevious<cr>", opts) -- aka `gT`
map("n", "<leader>td", ":tabclose<cr>", opts)
map("n", "<leader>tD", ":tabonly<cr>", opts) -- kill all except current tab

-- Project
------------
which_key_map.p = { name = "+project" }
map("n", "<leader>pt", ":NERDTreeToggleVCS<CR>", opts) -- open project tree
map("n", "<leader>po", ":NERDTreeFind<CR>", opts) -- reveal current file in project
map("n", "<leader>pf", ":GitFiles<CR>", opts) -- find in git-recognized files


-- Files
----------
which_key_map.f = { name = "+files" }
map("n", "<leader>ft", ":NerdTreeToggle<CR>", opts) -- open files tree
map("n", "<leader>fr", ":History<CR>", opts) -- recent files
map("n", "<leader>fc", ":e ~/.config/nvim/init.lua<CR>", opts)
map("n", "<leader>ff", ":Files<CR>", opts) -- find in pwd


-- Triggers
-------------
which_key_map.T = { name = "+triggers" }
map("n", "<leader>Tn", ":set number!<CR>", opts)


-- Notes
----------
which_key_map.n = { name = "+notes" }
map("n", "<leader>nd", ":lua require('vapor').open_daily_note()<CR>", opts)
map("n", "<leader>ni", ":lua require('vapor').open_notes_index()<CR>", opts)
map("n", "<leader>nl", ":lua require('nabla').place_inline()<CR>", opts)
map("n", "<F5>", ":lua require('nabla').place_inline()<CR>", opts) -- nabla.vim recommends this


-- Root
---------
map("n", "<leader><esc>", ":nohlsearch<cr>", opts)


-- Local leader
-----------------
which_key_local_map.l = { name = "+lsp" }
-- The actual keymap is set in LSP `on_attach` callback in `lua/settings.lua`.

-- TODO: bind the keybindings only for python files
which_key_local_map.s = { name = "+repl" }
map("n", "<localleader>sc", ":JupyterConnect<CR>", opts)
map("n", "<localleader>sd", ":JupyterDisconnect<CR>", opts)
map("n", "<localleader>sb", ":JupyterRunFile<CR>", opts)
map("n", "<localleader>se", ":JupyterRunCell<CR>", opts)
map("n", "<localleader>sk", ":JupyterTerminateKernel<CR>", opts)
map("v", "<localleader>sr", ":JupyterSendRange<CR>", opts)


-- `vim.g` variables can't be modified in place from lua
vim.g.which_key_map = which_key_map
vim.g.which_key_local_map = which_key_local_map

