--------
-- UI --
--------

-- Buffer- or window-local options that we want to provide deafults for need
-- to be set both globally and "locally".
-- See https://oroques.dev/notes/neovim-init/#set-options

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
vim.o.scrolloff = 8
vim.wo.scrolloff = 8

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
-- Config taken from: https://github.com/hrsh7th/nvim-cmp#recommended-configuration
-- Lua syntax: https://neovim.io/doc/user/lua-guide.html#_-vim.opt
-- vim.opt.completeopt = { "menu", "menuone", "noselect" }

-- Switch buffers without saving
vim.o.hidden = true

-- Show trailing spaces & tabs.
vim.o.list = true
vim.wo.list = true

-- Don't soft wrap in the middle of a word
vim.o.linebreak = true


-- Disable the bottom line with mode name like "-- INSERT --". Status line
-- already provides this information.
vim.o.showmode = false

-- Set langauge
vim.cmd [[language en_US.UTF-8]]

-- Use a single, unified status line regardless of the number of windows. Works
-- with neovim>=0.7.
vim.o.laststatus = 3

-- Hide command line if not currently writing a command. Works with neovim >=0.8.
-- vim.o.cmdheight = 0

-- Show horizontal line at cursor row.
vim.opt.cursorline = true

-- Show gitsigns & diagnostics over the line numbers. There's an issue where the status
-- line background isn't applied to the sign column. This setting makes it a little
-- less annoying. See also: https://github.com/lewis6991/gitsigns.nvim/issues/563
vim.opt.signcolumn = "number"

-- Make the `/` buffer search case insensitive unless the pattern includes at
-- least one capital letter.
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Make `:find` work recursively. Override the built-in default ("/usr/include").
vim.opt.path = "**"

---------------
-- which-key --
---------------
require("which-key").setup {
}



---------------
-- shade.nvim --
---------------
-- Enabling this clears startup screen :(
-- require("shade").setup {
-- }


-----------------------------
-- nvim-search-and-replace --
-----------------------------
require("nvim-search-and-replace").setup()


------------------
-- sidebar.nvim --
------------------

require("sidebar-nvim").setup({
    -- sections = { "datetime", "git", "diagnostics" },
    sections = { "files", "symbols", "git", },
    files = {
        -- show_hidden = false,
        show_hidden = true,
    },
})


----------------
-- image.nvim --
----------------
require('image').setup {}


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


------------
-- Colors --
------------
-- Without this, moonfly uses old vi colors.
-- vim.o.termguicolors = true

-- Without this, moonfly uses gray blocks for window separators.

require('ayu').setup({
    mirage = false, -- Set to `true` to use `mirage` variant instead of `dark` for dark background.
    overrides = {}, -- A dictionary of group names, each associated with a dictionary of parameters (`bg`, `fg`, `sp` and `style`) and colors in hex.
})
require('ayu').colorscheme()

----------------
-- Treesitter --
----------------

-- General config --
-------------------------------

-- Enable all common functionality

require "nvim-treesitter.configs".setup {
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

--------------------------
-- TreeSitter Additions --
--------------------------
require('sibling-swap').setup {}

--------------------
-- Autocompletion --
--------------------

local cmp = require("cmp")

-- setup nvim-cmp
cmp.setup({
    snippet = {
        -- REQUIRED - you must specify a snippet engine
        expand = function(args)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
    }),
    -- Don't show the text like "Function" after the symbol
    -- src: https://github.com/hrsh7th/nvim-cmp#how-to-show-name-of-item-kind-and-source-like-compe
    formatting = {
        format = require("lspkind").cmp_format({
            with_text = false,
        }),
    },
})


-- -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
-- cmp.setup.cmdline('/', {
--     mapping = cmp.mapping.preset.cmdline(),
--     sources = {
--         { name = 'buffer' }
--     }
-- })


-----------
-- Fuzzy --
-----------

-- Allow fuzzy matching in autocomplete popup
vim.g.completion_matching_strategy_list = { "exact", "substring", "fuzzy", }

-----------------
-- Status line --
-----------------

-- Based on:
-- * https://www.reddit.com/r/neovim/comments/ojnie2/comment/h52uy92/?utm_source=share&utm_medium=web2x&context=3
-- * https://github.com/hoob3rt/lualine.nvim#custom-components
local function ts_statusline()
    return require("nvim-treesitter").statusline()
end

-- Simulates how Emacs shows currently active minor modes on the status line.
local function minor_mode_status()
    local status = ""
    if (vim.inspect(vim.b.venn_enabled) ~= "nil") then
        status = status .. "V"
    end
    return status
end

require("lualine").setup {
    sections = {
        lualine_a = {
            {
                -- Show buffer number using the vim status line format:
                -- https://vimdoc.sourceforge.net/htmldoc/options.html#'statusline'
                "%n",

                separator = { left = "", right = "" },
            }
        },
        lualine_b = {
            {
                "filename",
                -- Show relative path.
                path = 1,

                -- Show symbols after the filepath. Src: https://github.com/nvim-lualine/lualine.nvim#buffers-component-options
                symbols = {
                    modified = ' ●', -- Text to show when the buffer is modified
                    alternate_file = '#', -- Text to show to identify the alternate file
                    directory = '', -- Text to show when the buffer is a directory
                },
            }
        },
        lualine_c = { ts_statusline },
        lualine_x = {
            minor_mode_status,
            {
                "diagnostics",
                sources = { "nvim_diagnostic", },
            },
            "fileformat",
            "filetype",
        },
        lualine_z = {
            -- Override default separators.
            {
                "location",
                separator = { left = "", right = "" },
            },
        }
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


---------------------
-- Symbols sidebar --
---------------------

require("aerial").setup {}

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
    scratch_dir = "~/Documents/notes-synced/daily",
    todo_dir = "~/Documents/notes-synced/todo",
}


----------------
-- File types --
----------------

-- # defaults to "shiftwidth() * 2"
vim.api.nvim_command("let g:pyindent_open_paren = 'shiftwidth()'")

vim.g.markdown_folding = true