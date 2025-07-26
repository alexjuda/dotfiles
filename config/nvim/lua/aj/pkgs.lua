---------------
-- Paq config
---------------


local M = {}


M.setup = function()
    require "paq" {
        "savq/paq-nvim", -- Let Paq manage itself

        -- Packages to check out:
        -- * incremental rename https://github.com/smjonas/inc-rename.nvim

        -- Color Themes
        ----------
        "Shatur/neovim-ayu",
        "catppuccin/nvim",
        "rose-pine/neovim",
        "EdenEast/nightfox.nvim",

        -- UI
        -------
        -- View and edit directories in via text buffers.
        "stevearc/oil.nvim",

        -- leader keybindings helper window
        "folke/which-key.nvim",

        -- code parser for syntax highlight & folds
        { 'nvim-treesitter/nvim-treesitter', build = function() vim.cmd(":TSUpdate") end }, -- Update the parsers on plugin update

        -- Winbar-like window on the top with context information, eg. about current class.
        'nvim-treesitter/nvim-treesitter-context',

        -- File tree sidebar
        "nvim-neo-tree/neo-tree.nvim",

        -- Dependency for:
        -- * zen-mode
        "folke/twilight.nvim",

        -- Unclutter the UI and set a narrow viewport
        "folke/zen-mode.nvim",

        -- Dependency for:
        -- * neotree
        "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended

        -- Dependency for:
        -- * neotree
        "MunifTanjim/nui.nvim",

        -- nicer bottom status line
        'hoob3rt/lualine.nvim',

        -- copilot status in lualine
        "AndreM222/copilot-lualine",

        -- Dependency for:
        -- * gitsigns
        -- * telescope
        -- * neo-tree
        -- * nvim-spectre
        -- * todo-comments
        -- * neotest
        "nvim-lua/plenary.nvim",

        -- Git gutter & other goodies
        "lewis6991/gitsigns.nvim",

        -- Highlight TODOs in source code
        "folke/todo-comments.nvim",

        -- Find and replace
        "s1n7ax/nvim-search-and-replace",

        -- Open file/line in GitHub
        "almo7aya/openingh.nvim",

        -- Terminal keybindings for command mode
        "assistcontrol/readline.nvim",

        -- Close buffers after x mins of inactivity.
        "chrisgrieser/nvim-early-retirement",

        -- Create missing directory on :w.
        "jghauser/mkdir.nvim",

        -- Show marks on the sign column. Add utilities around managing marks.
        "chentoast/marks.nvim",

        -- Use neovim's diff mode to view git diffs.
        "sindrets/diffview.nvim",

        -- Simple utility for resolving git conflict markers. KISS.
        "akinsho/git-conflict.nvim",

        -- Project-wide search and replace
        "nvim-pack/nvim-spectre",

        -- Add tiny animations to yank operations.
        "rachartier/tiny-glimmer.nvim",

        -- View and edit CSVs.
        "hat0uma/csvview.nvim",

        -- Dependency for:
        -- * neotest
        "nvim-neotest/nvim-nio",

        -- Dependency for:
        -- * neotest
        "antoinemadec/FixCursorHold.nvim",

        -- Test runner and TUI.
        "nvim-neotest/neotest",

        -- Python support for neotest.
        "nvim-neotest/neotest-python",

        -- Eval code under cursor in a side REPL.
        "Vigemus/iron.nvim",

        -- Show vertical indentation guide lines.
        "lukas-reineke/indent-blankline.nvim",

        -- Render inline images inside markdown documents.
        "3rd/image.nvim",

        -- LSP
        --------

        -- Langauge Server configurations
        'neovim/nvim-lspconfig',

        -- fancy icons in LSP completion prompt
        "onsails/lspkind-nvim",

        -- autocomplete framework
        "hrsh7th/nvim-cmp",

        -- LSP-based source for cmp
        "hrsh7th/cmp-nvim-lsp",

        -- Symbols sidebar
        "stevearc/aerial.nvim",

        -- Fuzzy completion
        ---------------------
        "nvim-telescope/telescope.nvim",


        -- Editing
        ------------
        -- wrap selected block in chars
        'machakann/vim-sandwich',

        -- quick jumps between lines and words
        'phaazon/hop.nvim',

        -- allow selecting inside/outside tree-sitter objects, like functions
        'nvim-treesitter/nvim-treesitter-textobjects',

        -- draw ascii diagrams
        'jbyuki/venn.nvim',

        -- Delete trailing whitespaces
        "cappyzawa/trim.nvim",

        -- LLMs
        ------------
        "zbirenbaum/copilot.lua",

        -- Lang-specific
        ----------------

        -- Enables files like foo.py.jinja to be syntax highlighted as Python
        "https://gitlab.com/HiPhish/jinja.vim.git",

        -- Eval code snippets
        "jubnzv/mdeval.nvim",

        -- Inline markdown rendering, as much as it's possible in a TUI
        "MeanderingProgrammer/render-markdown.nvim",
    }
end


return M
