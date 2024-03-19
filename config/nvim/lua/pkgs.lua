---------------
-- Paq config
---------------

require "paq" {
    "savq/paq-nvim"; -- Let Paq manage itself

    -- Packages to check out:
    -- * incremental rename https://github.com/smjonas/inc-rename.nvim

    -- Color Themes
    ----------
    "Shatur/neovim-ayu";

    "catppuccin/nvim";

    -- UI
    -------
    -- Edit directories
    'elihunter173/dirbuf.nvim';

    -- leader keybindings helper window
    "folke/which-key.nvim";

    -- code parser for syntax highlight & folds
    { 'nvim-treesitter/nvim-treesitter', build = function() vim.cmd(":TSUpdate") end }; -- Update the parsers on plugin update

    -- File tree sidebar
    "nvim-neo-tree/neo-tree.nvim";

    -- neo-tree's deps
    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    "MunifTanjim/nui.nvim",

    -- nicer bottom status line
    'hoob3rt/lualine.nvim';

    -- common utilities needed by other plugins:
    -- * gitsigns
    -- * telescope
    -- * image.nvim
    -- * neo-tree
    -- * octo.nvim
    -- * data-viewer.nvim
    -- * nvim-spectre
    "nvim-lua/plenary.nvim";

    -- Git gutter & other goodies
    "lewis6991/gitsigns.nvim";

    -- Find and replace
    "s1n7ax/nvim-search-and-replace";

    -- Open file/line in GitHub
    "almo7aya/openingh.nvim";

    -- Terminal keybindings for command mode
    "assistcontrol/readline.nvim";

    -- Show image file preview as ASCII art
    "samodostal/image.nvim";

    -- Access GitHub PRs from neovim
    "pwntester/octo.nvim";

    -- Visualize tabular data files
    "VidocqH/data-viewer.nvim";

    -- Close buffers after x mins of inactivity.
    "chrisgrieser/nvim-early-retirement";

    -- Create missing directory on :w.
    "jghauser/mkdir.nvim";

    -- Use neovim's diff mode to view git diffs.
    "sindrets/diffview.nvim";

    -- Project-wide search and replace
    "nvim-pack/nvim-spectre";

    -- LSP
    --------

    -- langauge server configurations
    'neovim/nvim-lspconfig';

    -- fancy icons in LSP completion prompt
    "onsails/lspkind-nvim";

    -- autocomplete framework
    "hrsh7th/nvim-cmp";

    -- LSP-based source for cmp
    "hrsh7th/cmp-nvim-lsp";

    -- Show callable signature when writing invocation
    "ray-x/lsp_signature.nvim";

    -- Symbols sidebar
    "stevearc/aerial.nvim";

    -- Highlight symbol under cursor, automatically
    "RRethy/vim-illuminate";

    -- Fuzzy completion
    ---------------------

    {"nvim-telescope/telescope.nvim", branch="0.1.0"};


    -- Editing
    ------------
    -- trigger comments with `gcc`
    'tpope/vim-commentary';

    -- wrap selected block in chars
    'machakann/vim-sandwich';

    -- quick jumps between lines and words
    'phaazon/hop.nvim';

    -- allow selecting inside/outside tree-sitter objects, like functions
    'nvim-treesitter/nvim-treesitter-textobjects';

    -- swap treesitter objects --
    "Wansmer/sibling-swap.nvim";

    -- draw ascii diagrams
    'jbyuki/venn.nvim';

    -- help for writing unicode characters
    "chrisbra/unicode.vim";

    -- align text, e.g. markdown tables
    "junegunn/vim-easy-align";

    -- Lang-specific
    ----------------

    -- Eval code snippets
    "jubnzv/mdeval.nvim";

    ----------
    -- Notes
    ----------
    -- LaTeX syntax & autocompiling
    { "lervag/vimtex" };

    -- Render markdown notes in a side browser.
    { "iamcco/markdown-preview.nvim", build = function() vim.fn["mkdp#util#install"]() end };
}
