" Spacemacs, forever in our hearts.
let g:mapleader = "\<Space>"
let g:maplocalleader = ','

" Define prefix dictionary for better descriptions
call which_key#register('<Space>', "g:which_key_map")
let g:which_key_map = {}

" Fire up WhichKey on leader keystroke
nnoremap <silent> <leader>      :<c-u>WhichKey '<Space>'<CR>
nnoremap <silent> <localleader> :<c-u>WhichKey  ','<CR>

" ------
" Window
" ------
" Based on https://github.com/liuchengxu/vim-which-key#minimal-configuration
let g:which_key_map['w'] = {
      \ 'name' : '+windows' ,
      \ 'w' : ['<C-W>w'     , 'other-window']          ,
      \ 'd' : ['<C-W>c'     , 'delete-window']         ,
      \ '-' : ['<C-W>s'     , 'split-window-below']    ,
      \ '|' : ['<C-W>v'     , 'split-window-right']    ,
      \ '2' : ['<C-W>v'     , 'layout-double-columns'] ,
      \ 'h' : ['<C-W>h'     , 'window-left']           ,
      \ 'j' : ['<C-W>j'     , 'window-below']          ,
      \ 'l' : ['<C-W>l'     , 'window-right']          ,
      \ 'k' : ['<C-W>k'     , 'window-up']             ,
      \ 'H' : ['<C-W>5<'    , 'expand-window-left']    ,
      \ 'J' : [':resize +5' , 'expand-window-below']   ,
      \ 'L' : ['<C-W>5>'    , 'expand-window-right']   ,
      \ 'K' : [':resize -5' , 'expand-window-up']      ,
      \ '=' : ['<C-W>='     , 'balance-window']        ,
      \ 's' : ['<C-W>s'     , 'split-window-below']    ,
      \ 'v' : ['<C-W>v'     , 'split-window-below']    ,
      \ }


" -------
" Buffers
" -------
" Based on https://github.com/liuchengxu/vim-which-key#minimal-configuration
let g:which_key_map['b'] = {
      \ 'name' : '+buffers',
      \ 'b' : [':Buffers', 'list-buffers'],
      \ 'd' : [':bdelete', 'delete-buffer'],
      \ 'D' : [':%bd|e#', 'delete all other buffers'],
      \ 'n' : [':bn', 'next-buffer'],
      \ 'p' : [':bp', 'prev-buffer'],
      \ 'r' : [':edit', 'reload buffer from disk'],
      \ }

" Switch to last buffer
nnoremap <leader><TAB> <C-^>


" -------
" Project
" -------
let g:which_key_map['p'] = {
      \ 'name' : '+project' ,
      \ 't' : ['NERDTreeToggleVCS' , 'open-project-tree'],
      \ 'o' : ['NERDTreeFind' , 'reveal current file in project'],
      \ 'f' : ['Files' , 'find-in-pwd'],
      \ }


" -----
" Files
" -----
nnoremap <leader>ff :Files ~/

let g:which_key_map['f'] = {
      \ 'name' : '+files' ,
      \ 't' : ['NERDTreeToggle' , 'open-files-tree'],
      \ 'r' : ['History' , 'recent-files'],
      \ 'f' : 'find-in-path',
      \ }


" ---
" LSP
" ---
let g:which_key_map['c'] = {
      \ 'name': '+lsp' ,
      \ }
" Config inspired by https://neovim.io/doc/user/lsp.html
nnoremap K <cmd>lua vim.lsp.buf.hover()<CR>
" Fire completion-nvim popup
imap <C-Space> <Plug>(completion_trigger)

" Standard LSP commands
nnoremap <leader>cd <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <leader>ch <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <leader>ct <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <leader>cs <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <leader>cD <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <leader>cr <cmd>lua vim.lsp.buf.rename()<CR>
nnoremap <leader>cf <cmd>lua vim.lsp.buf.formatting()<CR>


" -------
" Plugins
" -------
autocmd FileType markdown nmap <buffer> <localleader>p <Plug>MarkdownPreview

" -----
" Notes
" -----
let g:which_key_map['n'] = {
      \ 'name': '+notes' ,
      \ }
nnoremap <leader>nd <cmd>lua require('vapor').open_daily_note()<CR>
nnoremap <leader>ni <cmd>lua require('vapor').open_notes_index()<CR>


" --------
" Triggers
" --------
let g:which_key_map['t'] = {
      \ 'name': '+triggers' ,
      \ }
nnoremap <leader>tn :set number!<CR>


" ------
" Search
" ------
let g:which_key_map['s'] = {
      \ 'name' : '+search' ,
      \ 'p' : [':Rg', 'search in project'],
      \ }


" -----
" Misc
" -----
" Display fuzzy commands buffer
nnoremap <leader><Space> :Commands<CR>

