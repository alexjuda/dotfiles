local map = vim.api.nvim_set_keymap
opts = { noremap = true }


-- Leaders
------------
vim.g.mapleader = " " -- set space as the leader key
map("n", "<Space>", "", {}) -- disable actions for space


-- Buffers
------------
map("n", "<leader>bn", ":bnext<cr>", opts)
map("n", "<leader>bp", ":bprev<cr>", opts)
map("n", "<leader>bd", ":bdelete<cr>", opts)
map("n", "<leader><TAB>", "<C-^>", opts) -- switch to last buffer


-- Project
------------
map("n", "<leader>pt", ":NERDTreeToggleVCS<CR>", opts) -- open project tree
map("n", "<leader>po", ":NERDTreeFind<CR>", opts) -- reveal current file in project
map("n", "<leader>pf", ":Files<CR>", opts) -- find in pwd

-- Files
----------
map("n", "<leader>ft", ":NerdTreeToggle<CR>", opts) -- open files tree
map("n", "<leader>fr", ":History<CR>", opts) -- recent files

-- Root
---------
map("n", "<leader><esc>", ":nohlsearch<cr>", opts)
