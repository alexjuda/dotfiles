--------
-- UI --
--------

-- Buffer- or window-local options that we want to provide deafults for need
-- to be set both globally and "locally". 
-- See https://oroques.dev/notes/neovim-init/#set-options

-- Improve scrolling performance, especially in tmux
vim.o.lazyredraw = true

-- Make splits happen at the other part of the screen
vim.o.splitbelow = true
vim.o.splitright = true

-- Use point system clipboard to the default register
vim.o.clipboard = "unnamed"

-- Speed up firing up the WhichKey pane.
-- By default timeoutlen is 1000 ms.
vim.o.timeoutlen = 200

-- Tab size
vim.o.tabstop = 4
vim.bo.tabstop = 4
vim.o.shiftwidth = 4
vim.bo.shiftwidth = 4
vim.o.expandtab = true
vim.bo.expandtab = true

-- Ask for confirmation instead of failing by default
vim.o.confirm = true

-- Show at least one more line when scrolling
vim.o.scrolloff = 1
vim.wo.scrolloff = 1

-- Highlight line under cursor
vim.o.cursorline = true
vim.wo.cursorline = true

-- Show line numbers
vim.o.number = true
vim.wo.number = true

-- Add some left margin
vim.o.numberwidth = 6
vim.wo.numberwidth = 6

-- Enable scrolling with mouse
vim.o.mouse = "a"

-- Improve experience with nvim-completion
vim.o.completeopt = "menuone,noinsert,noselect"

-- Switch buffers without saving
vim.o.hidden = true


------------
-- Colors --
------------

require("colorbuddy").colorscheme("onebuddy")

----------------
-- Treesitter --
----------------

-- highlight
require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    -- custom_captures = {
    --   -- Highlight the @foo.bar capture group with the "Identifier" highlight group.
    --   ["foo.bar"] = "Identifier",
    -- },
  },
}

-- incremental selection
require'nvim-treesitter.configs'.setup {
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },
}

-- indentation
require'nvim-treesitter.configs'.setup {
  indent = {
    enable = true
  }
}

-- folding
-- Use treesitter's expressions to form folds
vim.o.foldmethod="expr"
vim.o.foldexpr="nvim_treesitter#foldexpr()"

-----------
-- Fuzzy --
-----------

-- Allow fuzzy matching in autocomplete popup
-- Tis no work yo :(
-- vim.g.completion_matching_strategy_list = { "exact", "substring", "fuzzy", }

-- setup nvim-lspfuzzy
require("lspfuzzy").setup {}

-----------
-- Notes --
-----------

require("vapor").setup {
    daily_notes_dir = "~/Documents/notes-synced/daily",
    notes_index_file = "~/Documents/notes-synced/README.md",
}


----------------
-- File types --
----------------

-- # defaults to 'shiftwidth() * 2'
vim.api.nvim_command("let g:pyindent_open_paren = 'shiftwidth()'")
