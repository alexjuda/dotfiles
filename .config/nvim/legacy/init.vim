" =======
" Plugins
" =======
source $HOME/.config/nvim/plug.vim

" ======
" Config
" ======
 
" ------
" Colors
" ------

lua require('colorbuddy').colorscheme('onebuddy')

" -------------
" UI management
" -------------

" Improve scrolling performance, especially in tmux
set lazyredraw

" Make splits happen at the other part of the screen
set splitbelow
set splitright

" Use point system clipboard to the default register
set clipboard=unnamed

" Speed up firing up the WhichKey pane.
" By default timeoutlen is 1000 ms.
set timeoutlen=200

" Tab size
set tabstop=4
set shiftwidth=4
set expandtab

" Ask for confirmation instead of failing by default
set confirm

" Show at least one more line when scrolling
set scrolloff=1

" Highlight line under cursor
set cursorline

" Show line numbers
set number

" Add some left margin
set numberwidth=6

" Enable scrolling with mouse
set mouse=a

" ----------
" Treesitter
" ----------

" Highlight
" ---------

lua <<EOF
require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    -- custom_captures = {
    --   -- Highlight the @foo.bar capture group with the "Identifier" highlight group.
    --   ["foo.bar"] = "Identifier",
    -- },
  },
}
EOF

" Incremental selection
" ---------------------

lua <<EOF
require'nvim-treesitter.configs'.setup {
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },
}
EOF


" Indentation
" -----------

lua <<EOF
require'nvim-treesitter.configs'.setup {
  indent = {
    enable = true
  }
}
EOF

" Folding
" -------

" Use treesitter's expressions to form folds
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()


" ---
" LSP
" ---

" Python
" ---

" Uncomment when debugging LSP
" vim.lsp.set_log_level("info")

" NOTE: in order for `pyls` to work with project files and project
" dependencies (e.g. jump to definiton to a 3rd-party library)
" you have to either:
" - pass hardcoded path to settings under the 
"   "pyls.plugins.jedi.environment" settings, or
" - activate the python venv shell and start `nvim` process from that shell
lua << EOF
settings = {
    pyls = {
        configurationSources = {"flake8"};
    };
}
require'lspconfig'.pyls.setup{settings = settings}
EOF

" lua << EOF
" settings = {}
" require'lspconfig'.pyright.setup{settings = settings}
" EOF

" JSON
" ----

" Requires installing the LS via npm externally:
" npm install -g vscode-json-languageserver

lua << EOF
require'lspconfig'.jsonls.setup {
    commands = {
      Format = {
        function()
          vim.lsp.buf.range_formatting({},{0,0},{vim.fn.line("$"),0})
        end
      }
    }
}
EOF

" --------------
" Autocompletion
" --------------

" Use completion-nvim in every buffer
autocmd BufEnter * lua require'completion'.on_attach()

" Recommended settings from https://github.com/nvim-lua/completion-nvim:
" - Set completeopt to have a better completion experience
set completeopt=menuone,noinsert,noselect
" - Avoid showing message extra message when using completion
set shortmess+=c

" Allow fuzzy matching in autocompletion popup
let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy']

" Use fzf for some LSP commands' output.  Overrides default vim-lsp hooks.
lua require('lspfuzzy').setup {}


" -----
" Notes
" -----

" Setup syntax highlighting in markdown files
let g:markdown_fenced_languages = ['html', 'python', 'bash=sh']

" Setup vapor notes
lua << EOF
require('vapor').setup{
    daily_notes_dir = "~/Documents/notes-synced/daily";
    notes_index_file = "~/Documents/notes-synced/README.md";
}
EOF

" ----------
" Custom fns
" ----------
"
" Reload nvim config
command! ReloadNvimConfig source $MYVIMRC

" -----------------
" Leaders + keymaps
" -----------------
source $HOME/.config/nvim/keymap.vim
