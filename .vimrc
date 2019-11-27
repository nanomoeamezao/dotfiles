filetype off
execute pathogen#infect()
syntax on
" set Vim-specific sequences for RGB colors
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
set termguicolors
set background=dark
colorscheme solarized8
filetype plugin indent on
set splitbelow
set splitright
set foldmethod=indent
set foldlevel=99
nnoremap <space> za
let mapleader = ","
nmap <leader>w :w!<cr>
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM user interface
" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" " Set 7 lines to the cursor - when moving vertically using j/k
set so=7
" " Turn on the Wild menu
set wildmenu
" " Ignore compiled files
set wildignore=*.o,*~,*.pyc
 if has("win16") || has("win32")
   set wildignore+=.git\*,.hg\*,.svn\*
    else
       set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
       endif
"Always show current position
"set ruler
set relativenumber
"" Height of the command bar
set cmdheight=2
" A buffer becomes hidden when it is abandoned
set hid
" " Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l
" " Ignore case when searching
set ignorecase
" " When searching try to be smart about cases 
set smartcase
" " Highlight search results
set hlsearch
" " Makes search act like search in modern browsers
set incsearch 
" " Don't redraw while executing macros (good performance config)
set lazyredraw 
set ttimeoutlen=5
set noerrorbells
set novisualbell
set t_vb=
set tm=500
set smarttab
set tabstop=4
set softtabstop=4
set shiftwidth=4
set noexpandtab
"set autoread
set encoding=utf-8 
set nobackup
set noswapfile
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Moving around, tabs, windows and buffers
" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" " Disable highlight when <leader><cr> is pressed
map <silent> <leader><cr> :noh<cr>
" " Smart way to move between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l
" " Close the current buffer
map <leader>bd :bclose<cr>:tabclose<cr>gT
" " Close all the buffers
map <leader>ba :bufdo bd<cr>
map <leader>l :bnext<cr>
map <leader>h :bprevious<cr>
" " Useful mappings for managing tabs
map <leader>tn :tabnew<cr>
map <leader>to :tabonly<cr>
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove 
map <leader>t<leader> :tabnext<cr> 
 " Let 'tl' toggle between this and the last accessed tab
let g:lasttab = 1
nmap <Leader>tl :exe "tabn ".g:lasttab<CR>
au TabLeave * let g:lasttab = tabpagenr()
" " Opens a new tab with the current buffer's path
" " Super useful when editing files in the same directory
map <leader>te :tabedit <c-r>=expand("%:p:h")<cr>/
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Editing mappings
" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" " Remap VIM 0 to first non-blank character
map 0 ^
" Move a line of text using ALT+[jk] or Command+[jk] on mac
nmap <M-j> mz:m+<cr>`z
nmap <M-k> mz:m-2<cr>`z
"vmap <M-j> :m'>+<cr>`<my`>mzgv`yo`z
"vmap <M-k> :m'<-2<cr>`>my`<mzgv`yo`z
map <leader>g  :YcmCompleter GoToDefinitionElseDeclaration<CR>
set nu
set clipboard=unnamed
let g:NERDTreeWinPos = "right"
let NERDTreeShowHidden=0
let NERDTreeIgnore = ['\.pyc$', '__pycache__']
let g:NERDTreeWinSize=35
map <leader>nn :NERDTreeToggle<cr>
map <leader>nb :NERDTreeFromBookmark<Space>
map <leader>nf :NERDTreeFind<cr>
"pymode stuff
"let g:pymode_lint_select = ["W0011", "W430"]
"let g:pymode_rope_completion = 0
"let g:pymode_lint_ignore = ["E501", "W"]
"let g:pymode_python = 'python3'
"autocmd BufRead *.py setlocal colorcolumn=0
"let g:pymode_options_colorcolumn = 0
"ycm completion
"let g:ycm_global_ycm_extra_conf = "~/.vim/.ycm_extra_conf.py"
let g:ycm_auto_trigger = 0
let g:ycm_complete_in_strings = 0 
" Airline stuff
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme='solarized'
" special markdown setup
let g:instant_markdown_slow = 1
