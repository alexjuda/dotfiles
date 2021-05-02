" =======
" Plugins
" =======

call plug#begin('~/.local/share/nvim/plugged')

" -----
" Theme 
" -----
Plug 'tjdevries/colorbuddy.vim'
Plug 'Th3Whit3Wolf/onebuddy'

" --
" UI
" --
Plug 'scrooloose/nerdtree'
Plug 'liuchengxu/vim-which-key'
Plug 'airblade/vim-rooter'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'} " Update the parsers on plugin update

" ----------------
" Fuzzy completion
" ----------------
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" fuzzy matching for LSP completion
Plug 'nvim-lua/completion-nvim'

" fuzzy matching for other LSP commands
Plug 'ojroques/nvim-lspfuzzy'

" -------
" Editing
" -------
Plug 'tpope/vim-commentary'
Plug 'machakann/vim-sandwich'


" -----
" Notes
" -----
Plug 'tpope/vim-markdown'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}

" ---
" LSP
" ---
Plug 'neovim/nvim-lspconfig'

call plug#end()

