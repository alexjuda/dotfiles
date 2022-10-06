---------------
-- Paq config
---------------

require "paq" {
    "savq/paq-nvim"; -- Let Paq manage itself

    -- Packages to check out:
    -- * incremental rename https://github.com/smjonas/inc-rename.nvim

    --------------
    -- Packages
    --------------

    -- Theme
    ----------
    "folke/tokyonight.nvim";
    "ellisonleao/gruvbox.nvim";

    -- UI
    -------
    -- lua-based tree explorer
    'kyazdani42/nvim-tree.lua';

    -- leader keybindings helper window
    "folke/which-key.nvim";

    -- `cd` after opening a file
    'airblade/vim-rooter';

    -- code parser for syntax highlight & folds
    { 'nvim-treesitter/nvim-treesitter', run = function() vim.cmd(":TSUpdate") end }; -- Update the parsers on plugin update

    -- nice icons in bufferline & file tree
    'kyazdani42/nvim-web-devicons';

    -- show icons in NERDTree
    'ryanoasis/vim-devicons';

    -- nicer bottom status line
    'hoob3rt/lualine.nvim';

    -- common utilities needed by other plugins:
    -- * gisigns
    "nvim-lua/plenary.nvim";

    -- Git gutter & other goodies
    "lewis6991/gitsigns.nvim";

    -- Dim inactive windows
    "sunjon/shade.nvim";

    -- Find and replace
    "s1n7ax/nvim-search-and-replace";

    -- Clipboard manager
    "gennaro-tedesco/nvim-peekup";

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

    -- Fuzzy completion
    ---------------------
    { 'junegunn/fzf', run = vim.fn["fzf#install"] };
    'junegunn/fzf.vim';


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

    -- draw ascii diagrams
    'jbyuki/venn.nvim';

    -- help for writing unicode characters
    "chrisbra/unicode.vim";

    -- quasi-smooth scrolling
    "karb94/neoscroll.nvim";


    -- Lang-specific
    ----------------
    -- Write jupyter notebooks from vim
    "untitled-ai/jupyter_ascending.vim";

    ----------
    -- Notes
    ----------
    -- Render markdown in a side browser window.
    { "iamcco/markdown-preview.nvim", run = "cd app && npm install" };

    -- LaTeX syntax & autocompiling
    { "lervag/vimtex" };
}
