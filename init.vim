:set number
:set autoindent
:set tabstop=4
:set shiftwidth=4
:set smarttab
:set softtabstop=4
:set mouse=a
:set cursorline
:set hlsearch
:set clipboard+=unnamedplus

call plug#begin()

Plug 'http://github.com/tpope/vim-surround' " Surrounding ysw)
Plug 'https://github.com/preservim/nerdtree' " NerdTree
Plug 'https://github.com/tpope/vim-commentary' " For Commenting gcc & gc
Plug 'https://github.com/vim-airline/vim-airline' " Status bar
Plug 'https://github.com/ap/vim-css-color' " CSS Color Preview
Plug 'https://github.com/rafi/awesome-vim-colorschemes' " Retro Scheme
Plug 'https://github.com/neoclide/coc.nvim'  " Auto Completion
Plug 'https://github.com/ryanoasis/vim-devicons' " Developer Icons
Plug 'https://github.com/tc50cal/vim-terminal' " Vim Terminal
Plug 'https://github.com/preservim/tagbar' " Tagbar for code navigation
Plug 'https://github.com/terryma/vim-multiple-cursors' " CTRL + N for multiple cursors
Plug 'https://github.com/sbdchd/neoformat' " Cool formatter
Plug 'https://github.com/puremourning/vimspector' " Live debugger
set encoding=UTF-8

call plug#end()

" nnoremap <C-f> :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
" nnoremap <F2> :call CocActionAsync('jumpDefinition')<CR>
nnoremap <C-i> :call CocActionAsync('format')<CR>
nnoremap <C-b> :!g++ -std=c++17 -Wall %<CR>
nnoremap <C-r> :!g++ -std=c++17 -Wall % && ./a.out<CR>
nnoremap <A-k> :move -2<CR>
nnoremap <A-j> :move +1<CR>
nnoremap <silent><leader>F :Neoformat<CR>
" nnoremap <F3> :call CocAction('jumpReferences')<CR>

nmap <F8> :TagbarToggle<CR>

:set completeopt-=preview " For No Previews

" :colorscheme jellybeans
:colorscheme gruvbox

let g:NERDTreeDirArrowExpandable="+"
let g:NERDTreeDirArrowCollapsible="~"

" --- Just Some Notes ---
" :PlugClean :PlugInstall :UpdateRemotePlugins
"
" :CocInstall coc-python
" :CocInstall coc-clangd
" :CocInstall coc-snippets
" :CocCommand snippets.edit... FOR EACH FILE TYPE

" air-line
let g:airline_powerline_fonts = 1

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

" tagbar
let g:tagbar_autofocus=1
let g:tagbar_autoclose=1

" airline symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''

" vimspector
let g:vimspector_enable_mappings = 'HUMAN'
nmap <Leader>db <Plug>VimspectorBreakpoints

inoremap <expr> <Tab> pumvisible() ? coc#_select_confirm() : "<Tab>"
" nnoremap <F4> :CocCommand clangd.switchSourceHeader<CR>

" --- Run formatter on save ---
augroup fmt
  autocmd!
  autocmd BufWritePre * undojoin | Neoformat
augroup END

" --- Remove trailing whitespaces on save ---
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
au BufWinEnter * match ExtraWhitespace /\s\+$/
au InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
au InsertLeave * match ExtraWhitespace /\s\+$/
au BufWinLeave * call clearmatches()
