:set number
:set autoindent
:set tabstop=4
:set shiftwidth=4
:set smarttab
:set softtabstop=4
:set mouse=a
:set cursorline " highlight active line
:set hlsearch
:set clipboard+=unnamedplus " system clipboard
:set completeopt-=preview " For No Previews

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

" keybindings#begin()
" nerdtree
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
" vim-commentary
" tagbar
nmap <F8> :TagbarToggle<CR>
" neoformat
nnoremap <silent><leader>F :Neoformat<CR>
" vimspector
nmap <Leader>db <Plug>VimspectorBreakpoints
" coc-nvim
" nnoremap <C-f> :NERDTreeFocus<CR>
" nnoremap <F2> :call CocActionAsync('jumpDefinition')<CR>
" nnoremap <F3> :call CocAction('jumpReferences')<CR>
" nnoremap <F4> :CocCommand clangd.switchSourceHeader<CR>
nnoremap <silent> gd <Plug>(coc-definition)
nnoremap <silent> gy <Plug>(coc-type-definition)
nnoremap <silent> gi <Plug>(coc-implementation)
nnoremap <silent> gr <Plug>(coc-references)
nnoremap <silent> gf <Plug>(coc-format)
" nnoremap <C-i> :call CocActionAsync('format')<CR>
" gcc build related
nnoremap <C-b> :!g++ -std=c++17 -Wall %<CR>
nnoremap <C-r> :!g++ -std=c++17 -Wall % && ./a.out<CR>
" other nnoremap
nnoremap <A-k> :move -2<CR>
nnoremap <A-j> :move +1<CR>

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

" other inoremap

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()
inoremap <expr> <Tab> pumvisible() ? coc#_select_confirm() : "<Tab>"
" keybindings#end()

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" vim colorscheme
:colorscheme gruvbox

let g:NERDTreeDirArrowExpandable="+"
let g:NERDTreeDirArrowCollapsible="~"
let g:NERDTreeShowHidden=1

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
