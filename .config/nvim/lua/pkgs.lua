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
{'tjdevries/colorbuddy.vim'};
{'Th3Whit3Wolf/onebuddy'};


-- UI
-------
-- file explorer
{ 'scrooloose/nerdtree' };
-- leader keybindings helper window
{ 'liuchengxu/vim-which-key' };
-- `cd` after opening a file
{ 'airblade/vim-rooter' };
-- code parser for syntax highlight & folds
{'nvim-treesitter/nvim-treesitter', run=function() vim.cmd(":TSUpdate") end}; -- Update the parsers on plugin update

-- buffers presented in a tab bar + fancy icons
{'akinsho/nvim-bufferline.lua'};
{'kyazdani42/nvim-web-devicons'};

-- nicer bottom status line
{'itchyny/lightline.vim'};


-- LSP
-- -----
{'neovim/nvim-lspconfig'};


-- Fuzzy completion
---------------------
{'junegunn/fzf', run=vim.fn["fzf#install"]};
{'junegunn/fzf.vim'};

-- fuzzy matching for LSP completion
{'nvim-lua/completion-nvim'};

-- fuzzy matching for other LSP commands
{'ojroques/nvim-lspfuzzy'};


-- Editing
------------
-- trigger comments with `gcc`
{'tpope/vim-commentary'};
-- wrap selected block in chars
'machakann/vim-sandwich';

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
'tpope/vim-markdown';
-- Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
'jbyuki/nabla.nvim';

}
