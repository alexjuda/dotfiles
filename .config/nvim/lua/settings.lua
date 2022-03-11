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

-- Show trailing spaces & tabs.
vim.o.list = true
vim.wo.list = true

-- Don't soft wrap in the middle of a word
vim.o.linebreak = true

-- Required by bufferline
vim.o.termguicolors = true


-- Disable the bottom line with mode name like "-- INSERT --". Status line
-- already provides this information.
vim.o.showmode = false

-- Set langauge
vim.cmd[[language en_US.UTF-8]]

---------------
-- which-key --
---------------
require("which-key").setup {
}


--------------
-- NvimTree --
--------------

require("nvim-tree").setup {
  -- (default false) closes neovim automatically when the tree is the last **WINDOW** in the view
  -- auto_close = false,

  -- update the focused file on `BufEnter`, un-collapses the folders recursively until it finds the file
  update_focused_file = {
    -- enables the feature (default false)
    enable = true,
    update_cwd = true,
  },

  view = {
    -- if true the tree will resize itself after opening a file
    auto_resize = true,
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

vim.g.tokyonight_style = "night"
vim.g.tokyonight_hide_inactive_statusline = true

vim.cmd[[colorscheme tokyonight]]

----------------
-- Treesitter --
----------------

-- General config --
-------------------------------

-- Enable all common functionality

require"nvim-treesitter.configs".setup {
  ensure_installed = {
    "bash",
    "html",
    "javascript",
    "json",
    "lua",
    "markdown",
    "python",
    "rst",
  },

  highlight = {
    enable = true,
  },

  indent = {
    enable = false,
  },

  -- tree-sitter objects for code navigation
  textobjects = {
    move = {
      enable = true,
      set_jumps = true,

      goto_previous_start = {
        ["[p"] = "@parameter.inner",
        ["[f"] = "@function.outer",
        ["[k"] = "@class.outer",
        ["[i"] = "@call.outer",
      },
      goto_previous_end = {
        ["[P"] = "@parameter.outer",
        ["[F"] = "@function.outer",
        ["[K"] = "@class.outer",
        ["[I"] = "@call.outer",
      },
      goto_next_start = {
        ["]p"] = "@parameter.inner",
        ["]f"] = "@function.outer",
        ["]k"] = "@class.outer",
        ["]i"] = "@call.outer",
      },
      goto_next_end = {
        ["]P"] = "@parameter.outer",
        ["]F"] = "@function.outer",
        ["]K"] = "@class.outer",
        ["]I"] = "@call.outer",
      },
    },

    select = {
      enable = true,

      -- Automatically jump forward to textobj, similar to targets.vim
      lookahead = true,

      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ai"] = "@call.outer",
        ["ii"] = "@call.inner",
        ["ak"] = "@class.outer",
        ["ik"] = "@class.inner",
        ["ap"] = "@parameter.outer",
        ["ip"] = "@parameter.inner",
      },
    },
  },
}


-- folding
-- Use treesitter's expressions to form folds
vim.o.foldmethod = "expr"
vim.o.foldexpr = "nvim_treesitter#foldexpr()"


--------------------
-- Autocompletion --
--------------------

local cmp = require("cmp")

-- setup nvim-cmp
cmp.setup({
    snippet = {
        expand = function(args)
            -- TODO
        end,
    },

    mapping = {
        ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
        ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
        ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
        ['<C-y>'] = cmp.config.disable, -- If you want to remove the default `<C-y>` mapping, You can specify `cmp.config.disable` value.
        ['<C-e>'] = cmp.mapping({
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
        }),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
    },

    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
    }, {
        { name = 'buffer' },
    }),

    -- Don't show the text like "Function" after the symbol
    -- src: https://github.com/hrsh7th/nvim-cmp#how-to-show-name-of-item-kind-and-source-like-compe
    formatting = {
        format = require("lspkind").cmp_format({
            with_text = false,
        }),
    },
})


-----------
-- Fuzzy --
-----------

-- Allow fuzzy matching in autocomplete popup
vim.g.completion_matching_strategy_list = { "exact", "substring", "fuzzy", }

-- nvim-lspfuzzy overrides LSP handlers to present list-based results in a fzf window
-- require("lspfuzzy").setup {}


-----------------
-- Status line --
-----------------

-- Based on:
-- * https://www.reddit.com/r/neovim/comments/ojnie2/comment/h52uy92/?utm_source=share&utm_medium=web2x&context=3
-- * https://github.com/hoob3rt/lualine.nvim#custom-components
local function ts_statusline()
    return require("nvim-treesitter").statusline()
end

require("lualine").setup {
    sections = {
        lualine_a = {},
        lualine_b = {
            {
                "filename",
                path = 1,
            }
        },
        lualine_c = { ts_statusline },
        lualine_x = {
            {
                "diagnostics",
                sources = { "nvim_diagnostic", },
            },
            "fileformat",
            "filetype",
        },
    },
    -- Show shorter status line in the nvim-tree side buffer.
    extensions = { "nvim-tree", }
}


---------------------
-- Show signatures --
---------------------

require("lsp_signature").setup {
    -- show signature in the middle of multi-line invocations
    always_trigger = true,
}


-----------------
-- Buffer tabs --
-----------------

require("bufferline").setup {}

-----------------
-- Git goodies --
-----------------

require("gitsigns").setup {}

-----------
-- Jumps --
-----------

require("hop").setup {}

-----------
-- Notes --
-----------

require("vapor").setup {
    -- quickfix for namespacing daily notes with a year
    daily_notes_dir = "~/Documents/notes-synced/daily/2022",
    notes_index_file = "~/Documents/notes-synced/README.md",
}


----------------
-- File types --
----------------

-- # defaults to "shiftwidth() * 2"
vim.api.nvim_command("let g:pyindent_open_paren = 'shiftwidth()'")

vim.g.markdown_folding = true
