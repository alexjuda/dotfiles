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

        -- UI
        -------
        -- Edit directories
        'elihunter173/dirbuf.nvim',

        -- leader keybindings helper window
        "folke/which-key.nvim",

        -- code parser for syntax highlight & folds
        { 'nvim-treesitter/nvim-treesitter', build = function() vim.cmd(":TSUpdate") end }, -- Update the parsers on plugin update

        -- File tree sidebar
        "nvim-neo-tree/neo-tree.nvim",

        -- Unclutter the UI and set a narrow viewport
        "folke/zen-mode.nvim",

        -- Dependency for:
        -- * neotree
        -- * lspsaga
        "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended

        -- Dependency for:
        -- * neotree
        "MunifTanjim/nui.nvim",

        -- nicer bottom status line
        'hoob3rt/lualine.nvim',

        -- Dependency for:
        -- * gitsigns
        -- * telescope
        -- * image.nvim
        -- * neo-tree
        -- * data-viewer.nvim
        -- * nvim-spectre
        -- * todo-comments
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

        -- Visualize tabular data files
        "VidocqH/data-viewer.nvim",

        -- Close buffers after x mins of inactivity.
        "chrisgrieser/nvim-early-retirement",

        -- Create missing directory on :w.
        "jghauser/mkdir.nvim",

        -- Use neovim's diff mode to view git diffs.
        "sindrets/diffview.nvim",

        -- Project-wide search and replace
        "nvim-pack/nvim-spectre",

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

        -- Show callable signature when writing invocation
        "ray-x/lsp_signature.nvim",

        -- Symbols sidebar
        "stevearc/aerial.nvim",

        -- Highlight symbol under cursor, automatically
        "RRethy/vim-illuminate",

        -- Improves the neovim built-in LSP experience. We're using it for winbar
        -- breadcrumbs.
        "nvimdev/lspsaga.nvim",

        -- Fuzzy completion
        ---------------------
        "nvim-telescope/telescope.nvim",


        -- Editing
        ------------
        -- trigger comments with `gcc`
        'tpope/vim-commentary',

        -- wrap selected block in chars
        'machakann/vim-sandwich',

        -- quick jumps between lines and words
        'phaazon/hop.nvim',

        -- allow selecting inside/outside tree-sitter objects, like functions
        'nvim-treesitter/nvim-treesitter-textobjects',

        -- draw ascii diagrams
        'jbyuki/venn.nvim',

        -- powertool for editing markdown tables
        "Myzel394/easytables.nvim",

        -- Lang-specific
        ----------------

        -- Eval code snippets
        "jubnzv/mdeval.nvim",
    }
end


return M
