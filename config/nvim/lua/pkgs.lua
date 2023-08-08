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

    -- UI
    -------
    -- Edit directories
    'elihunter173/dirbuf.nvim';

    -- leader keybindings helper window
    "folke/which-key.nvim";

    -- code parser for syntax highlight & folds
    { 'nvim-treesitter/nvim-treesitter', run = function() vim.cmd(":TSUpdate") end }; -- Update the parsers on plugin update

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
    "nvim-lua/plenary.nvim";

    -- Git gutter & other goodies
    "lewis6991/gitsigns.nvim";

    -- Find and replace
    "s1n7ax/nvim-search-and-replace";

    -- Open file/line in GitHub
    "almo7aya/openingh.nvim";

    -- Terminal keybindings for command mode
    "linty-org/readline.nvim";

    -- Show image file preview as ASCII art
    "samodostal/image.nvim";

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

    -- Lang-specific
    ----------------
    -- Run Python code interactively with Jupyter
    "dccsillag/magma-nvim";

    -- Send selection to a jupyter instance running in a qtconsole
    "jupyter-vim/jupyter-vim";

    -- Eval code snippets
    "jubnzv/mdeval.nvim";

    ----------
    -- Notes
    ----------
    -- Render markdown in a side browser window.
    { "iamcco/markdown-preview.nvim", run = "cd app && npm install" };

    -- LaTeX syntax & autocompiling
    { "lervag/vimtex" };
}
