--------------
-- Packages
--------------

-- Configure paq
----------------

vim.cmd 'packadd paq-nvim'         -- Load package

local paq = require'paq-nvim'.paq  -- Import module and bind `paq` function
paq {'savq/paq-nvim', opt=true}    -- Let Paq manage itself

-- Add packages
---------------

-- Theme 
--------
paq {'tjdevries/colorbuddy.vim'}
paq {'Th3Whit3Wolf/onebuddy'}

-- UI
-----
paq { 'scrooloose/nerdtree' }
paq { 'liuchengxu/vim-which-key' }
paq { 'airblade/vim-rooter' }
-- { 'nvim-treesitter/nvim-treesitter', run=vim.fn['TSUpdate']} -- Update the parsers on plugin update

-- ---
-- LSP
-- ---
paq {'neovim/nvim-lspconfig'}


-- Fuzzy completion
-------------------
-- paq {'junegunn/fzf', run= { -> fzf#install() } }
paq {'junegunn/fzf.vim'}

-- fuzzy matching for LSP completion
paq {'nvim-lua/completion-nvim'}

-- fuzzy matching for other LSP commands
paq {'ojroques/nvim-lspfuzzy'}


-- Editing
----------
paq {'tpope/vim-commentary'}
paq {'machakann/vim-sandwich'}

-- -----
-- Notes
-- -----
paq {'tpope/vim-markdown'}
-- Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}

