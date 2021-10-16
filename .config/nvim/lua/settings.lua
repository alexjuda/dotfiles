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
vim.o.clipboard = "unnamedplus"

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

-- Show line numbers
vim.o.number = true
vim.wo.number = true

-- Add some left margin
vim.o.numberwidth = 6
vim.wo.numberwidth = 6

-- Don't show tildes for end of buffer lines
vim.o.fillchars = vim.o.fillchars .. "eob: "

-- Enable scrolling with mouse
vim.o.mouse = "a"

-- Improve experience with nvim-completion
vim.o.completeopt = "menuone,noinsert,noselect"

-- Switch buffers without saving
vim.o.hidden = true

-- Set line lengths to 88 by default
-- vim.o.textwidth = 88
-- vim.bo.textwidth = 88


-- Required by bufferline
vim.o.termguicolors = true


-- Disable the bottom line with mode name like "-- INSERT --". Status line 
-- already provides this information.
vim.o.showmode = false


--------------
-- NvimTree --
--------------

require("nvim-tree").setup {
  -- (default false) closes neovim automatically when the tree is the last **WINDOW** in the view
  auto_close = true,

  -- update the focused file on `BufEnter`, un-collapses the folders recursively until it finds the file
  update_focused_file = {
    -- enables the feature (default false)
    enable = true,
  },
}

------------------
-- Autocommands --
------------------

-- Customize indent size
vim.cmd([[
augroup aj-set-file-indent-width 
    autocmd Filetype yaml setlocal shiftwidth=2
    autocmd Filetype html setlocal shiftwidth=2
augroup END
]])

-- Tame Tree-Sitter folds
-- source: https://stackoverflow.com/a/8316471
vim.cmd([[
augroup aj-open-folds-by-default 
    autocmd BufWinEnter * let &foldlevel = max(map(range(1, line('$')), 'foldlevel(v:val)'))
augroup END
]])


-- Highlight cursor line only in the active window
-- src: https://vim.fandom.com/wiki/Highlight_current_line
vim.cmd([[
augroup aj-active-window-cursorline
    au!
    au VimEnter,WinEnter,BufWinEnter,FocusGained * setlocal cursorline
    au WinLeave,FocusLost * setlocal nocursorline
augroup END
]])


------------
-- Colors --
------------

vim.cmd[[colorscheme dracula]]

----------------
-- Treesitter --
----------------

-- highlight
require"nvim-treesitter.configs".setup {
  highlight = {
    enable = true,
    -- custom_captures = {
    --   -- Highlight the @foo.bar capture group with the "Identifier" highlight group.
    --   ["foo.bar"] = "Identifier",
    -- },
  },
}

-- incremental selection
require"nvim-treesitter.configs".setup {
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
require"nvim-treesitter.configs".setup {
  indent = {
    enable = true
  }
}

-- folding
-- Use treesitter's expressions to form folds
vim.o.foldmethod = "expr"
vim.o.foldexpr = "nvim_treesitter#foldexpr()"

-- selecting tree-sitter objects
require("nvim-treesitter.configs").setup { 
  textobjects = {
    select = {
      enable = true,

      -- Automatically jump forward to textobj, similar to targets.vim 
      lookahead = true,

      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
      },
    },
  },
}

-----------
-- Fuzzy --
-----------

-- Allow fuzzy matching in autocomplete popup
vim.g.completion_matching_strategy_list = { "exact", "substring", "fuzzy", }

-- setup nvim-lspfuzzy
require("lspfuzzy").setup {}


-----------------
-- Status line --
-----------------

vim.g.lightline = {
    enable = {
        -- Disable lightline's buffer tab bar
        tabline = 0,
    },
    -- Match the status line's colors to the rest of the editor
    colorscheme = "one",
}


-----------------
-- Buffer tabs --
-----------------

require("bufferline").setup {}

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

-- # defaults to "shiftwidth() * 2"
vim.api.nvim_command("let g:pyindent_open_paren = 'shiftwidth()'")

vim.g.markdown_folding = true
