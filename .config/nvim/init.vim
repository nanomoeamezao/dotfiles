set runtimepath+=~/.cache/dein/repos/github.com/Shougo/dein.vim
if !exists('g:vscode')
  if dein#load_state('~/.cache/dein')
    call dein#begin('~/.cache/dein')
    call dein#add('~/.cache/dein/repos/github.com/Shougo/dein.vim')
    call dein#add('tpope/vim-surround.git')
    call dein#add('vim-airline/vim-airline')
    call dein#add('ctrlpvim/ctrlp.vim')
    call dein#add('vim-airline/vim-airline-themes')
    call dein#add('joshdick/onedark.vim')
    call dein#add('neoclide/coc.nvim', {'branch': 'release'})
    call dein#add('sheerun/vim-polyglot')
    call dein#add('antoinemadec/FixCursorHold.nvim')
    call dein#add('justinmk/vim-sneak')
    call dein#add('lambdalisue/fern.vim')
    if !has('nvim')
      call dein#add('roxma/nvim-yarp')
      call dein#add('roxma/vim-hug-neovim-rpc')
    endif
    call dein#end()
    call dein#save_state()
  endif
  if (has("termguicolors"))
    set termguicolors
  endif
endif
syntax on
" set Vim-specific sequences for RGB colors
"let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
"let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
filetype plugin indent on
set splitbelow

colorscheme onedark
let g:airline_theme='onedark'

set splitright
set foldmethod=indent
set foldlevel=99
nnoremap <space> za
let mapleader = ","
set omnifunc=syntaxcomplete#Complete
set keymap=russian-jcukenwin
set iminsert=0
set imsearch=0
set langmap=ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ
set langmap=фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz
nmap Ж :
map <leader>w :w!<cr>
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM user interface
" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set conceallevel=2
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
set updatetime=300
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
nmap <Leader>tl :exe "tabn ".g:lasttab<CR>
" " Opens a new tab with the current buffer's path
" " Super useful when editing files in the same directory
map <leader>te :tabedit <c-r>=expand("%:p:h")<cr>/
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Editing mappings
" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" " Remap VIM 0 to first non-blank character
map 0 ^
set nu
set clipboard=unnamed

" COC

