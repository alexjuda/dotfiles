---------------
-- Paq config
---------------

vim.cmd 'packadd paq-nvim'         -- Load package

local paq = require'paq-nvim'.paq  -- Import module and bind `paq` function
paq {'savq/paq-nvim', opt=true}    -- Let Paq manage itself

--------------
-- Packages
--------------

-- Theme 
----------
paq {'tjdevries/colorbuddy.vim'}
paq {'Th3Whit3Wolf/onebuddy'}


-- UI
-------
paq { 'scrooloose/nerdtree' }
paq { 'liuchengxu/vim-which-key' }
paq { 'airblade/vim-rooter' }
paq {'nvim-treesitter/nvim-treesitter', run=function() vim.cmd(":TSUpdate") end} -- Update the parsers on plugin update

-- buffers presented in a tab bar + fancy icons
paq {'akinsho/nvim-bufferline.lua'}
paq {'kyazdani42/nvim-web-devicons'}


-- LSP
-- -----
paq {'neovim/nvim-lspconfig'}


-- Fuzzy completion
---------------------
paq {'junegunn/fzf', run=vim.fn["fzf#install"]}
paq {'junegunn/fzf.vim'}

-- fuzzy matching for LSP completion
paq {'nvim-lua/completion-nvim'}

-- fuzzy matching for other LSP commands
paq {'ojroques/nvim-lspfuzzy'}


-- Editing
------------
-- trigger comments with `gcc`
paq {'tpope/vim-commentary'}
-- wrap selected block in chars
paq {'machakann/vim-sandwich'}


-- Integrations
-----------------
paq { 'jupyter-vim/jupyter-vim' }

----------
-- Notes
----------
paq {'tpope/vim-markdown'}
-- Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
paq {'jbyuki/nabla.nvim'}

