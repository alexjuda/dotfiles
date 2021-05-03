--------
-- UI --
--------

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
vim.o.shiftwidth = 4
vim.o.expandtab = true

-- Ask for confirmation instead of failing by default
vim.o.confirm = true

-- Show at least one more line when scrolling
vim.o.scrolloff = 1

-- Highlight line under cursor
vim.o.cursorline = true

-- Show line numbers
vim.o.number = true

-- Add some left margin
vim.o.numberwidth = 6

-- Enable scrolling with mouse
vim.o.mouse = "a"

------------
-- Colors --
------------

require("colorbuddy").colorscheme("onebuddy")

----------------
-- Treesitter --
----------------

-- Highlight
--------------

require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    -- custom_captures = {
    --   -- Highlight the @foo.bar capture group with the "Identifier" highlight group.
    --   ["foo.bar"] = "Identifier",
    -- },
  },
}

-- Incremental selection
--------------------------

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


-- Indentation
--------------

require'nvim-treesitter.configs'.setup {
  indent = {
    enable = true
  }
}

-- Folding
----------

-- Use treesitter's expressions to form folds
vim.o.foldmethod="expr"
vim.o.foldexpr="nvim_treesitter#foldexpr()"

