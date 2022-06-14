:set number
:set autoindent
:set tabstop=4
:set shiftwidth=4
:set smarttab
:set softtabstop=0
:set expandtab
:set mouse=a
:set cursorline " highlight active line
:set hlsearch
:set clipboard+=unnamedplus " system clipboard
:set completeopt-=preview " For No Previews
:set updatetime=200 " symbol highlight timeout

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
" Plug 'https://github.com/alpertuna/vim-header' " Adds headers to files
Plug 'https://github.com/attilarepka/vim-header' " TODO: If PR accepted update link
Plug 'https://github.com/ellisonleao/glow.nvim' " Markdown preview
Plug 'https://github.com/junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'https://github.com/junegunn/fzf.vim' " Search in files
set encoding=UTF-8

call plug#end()

" keybindings#begin()
" nerdtree
nnoremap <silent> nc :NERDTreeClose<CR>
nnoremap <silent> nt :NERDTreeToggle<CR>
nnoremap <silent> nf :NERDTreeFocus<CR>
" vim-commentary
" tagbar
nnoremap <silent> tt :TagbarToggle<CR>
" neoformat
nnoremap <silent><leader>F :Neoformat<CR>
" vimspector
nnoremap <leader>da :call vimspector#Launch()<CR>
nnoremap <leader>db <Plug>VimspectorBreakpoints
nnoremap <leader>vr :call vimspector#Reset()<CR>
" coc-nvim
nnoremap <silent> sh :CocCommand clangd.switchSourceHeader<CR>
nnoremap <silent> gd <Plug>(coc-definition)
nnoremap <silent> gy <Plug>(coc-type-definition)
nnoremap <silent> gi <Plug>(coc-implementation)
nnoremap <silent> gr <Plug>(coc-references)
nnoremap <silent> gf <Plug>(coc-format)
" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)
" vim-header
nnoremap <silent><leader>hh :AddHeader<CR>
" fzf
nnoremap <silent> ff :Files<CR>
nnoremap <silent> fr :Rg<CR>

" TODO: These are currently not working
nnoremap <C-LeftMouse> <Plug>(coc-definition)<CR>
" Remap for format selected region
xmap <leader>f <Plug>(coc-format-selected)
nmap <leader>f <Plug>(coc-format-selected)

" gcc build related
nnoremap <silent><leader>bp :!g++ -std=c++17 -Wall %<CR>
nnoremap <silent><leader>rp :!g++ -std=c++17 -Wall % && ./a.out<CR>
" other nnoremap
nnoremap <A-k> :move -2<CR>
nnoremap <A-j> :move +1<CR>

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()
inoremap <expr> <Tab> pumvisible() ? coc#_select_confirm() : "<Tab>"

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Glow toggle
nnoremap <silent><leader>mp :Glow<CR>

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

" NERDTree
let g:NERDTreeDirArrowExpandable="+"
let g:NERDTreeDirArrowCollapsible="~"
let g:NERDTreeShowHidden=1
" Close the tab if NERDTree is the only window remaining in it.
autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" --- Just Some Notes ---
" :PlugClean :PlugInstall :UpdateRemotePlugins
"
" :CocInstall coc-python
" :CocInstall coc-clangd
" :CocInstall coc-go
" :CocInstall coc-highlight
" :CocInstall coc-vimlsp
" :CocInstall coc-angular coc-tsserver coc-eslint coc-json coc-prettier coc-css

" C++ language server installation:
" sudo apt install ccls

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

" --- Organize Go imports on save ---
autocmd BufWritePre *.go :silent call CocAction('runCommand', 'editor.action.organizeImport')

" --- Remove trailing whitespaces on save ---
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
au BufWinEnter * match ExtraWhitespace /\s\+$/
au InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
au InsertLeave * match ExtraWhitespace /\s\+$/
au BufWinLeave * call clearmatches()

" --- setup Python3 support
let g:python_host_prog = '/usr/bin/python'
let g:python3_host_prog = '/usr/bin/python3'
" python3 -m pip install pynvim

" vim-header
let g:header_field_author = 'Some Author'
let g:header_field_author_email = 'some@email.domain'
let g:header_field_copyright = 'Some Copyright text'
let g:header_field_timestamp_format = '%d %b %Y %H:%M:%S'
let g:header_field_modified_timestamp = 0
let g:header_field_modified_by = 0
let g:header_field_project = 'Some Project'
let g:header_field_last_separator = 1
let g:header_alignment = 0
