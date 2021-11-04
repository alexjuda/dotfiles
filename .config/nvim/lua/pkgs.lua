---------------
-- Paq config
---------------

require "paq" {
    "savq/paq-nvim";                  -- Let Paq manage itself

    --------------
    -- Packages
    --------------

    -- Theme
    ----------
    "Mofiqul/dracula.nvim";
    "shaunsingh/nord.nvim";
    "bluz71/vim-nightfly-guicolors";
    "bluz71/vim-moonfly-colors";
    "rafamadriz/neon";
    "navarasu/onedark.nvim";

    -- UI
    -------
    -- lua-based tree explorer
    'kyazdani42/nvim-tree.lua';

    -- leader keybindings helper window
    'liuchengxu/vim-which-key';

    -- `cd` after opening a file
    'airblade/vim-rooter';

    -- code parser for syntax highlight & folds
    {'nvim-treesitter/nvim-treesitter', run=function() vim.cmd(":TSUpdate") end}; -- Update the parsers on plugin update

    -- treesitter debugging
    "nvim-treesitter/playground";

    -- buffers presented in a tab bar + fancy icons
    'akinsho/nvim-bufferline.lua';

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
    {'junegunn/fzf', run=vim.fn["fzf#install"]};
    'junegunn/fzf.vim';


    -- Editing
    ------------
    -- trigger comments with `gcc`
    'tpope/vim-commentary';

    -- wrap selected block in chars
    'machakann/vim-sandwich';

    -- training for motions
    'tjdevries/train.nvim';

    -- allow selecting inside/outside tree-sitter objects, like functions
    'nvim-treesitter/nvim-treesitter-textobjects';

    -- draw ascii diagrams
    'jbyuki/venn.nvim';


    -- Languages
    --------------
    -- Nix
    'LnL7/vim-nix';


    -- Integrations
    -----------------
    'jupyter-vim/jupyter-vim';

    ----------
    -- Notes
    ----------
    -- Render markdown in a side browser window.
    { "iamcco/markdown-preview.nvim", run="cd app && npm install" };
}
