set runtimepath+=~/.cache/dein/repos/github.com/Shougo/dein.vim
if !exists('g:vscode')
    call dein#begin('~/.cache/dein')
    call dein#add('~/.cache/dein/repos/github.com/Shougo/dein.vim')
    call dein#add('tpope/vim-surround.git')
    call dein#add('tpope/vim-fugitive')
    call dein#add('machakann/vim-highlightedyank')
    call dein#add('airblade/vim-gitgutter')
    call dein#add('vim-airline/vim-airline')
    call dein#add('vim-scripts/ReplaceWithRegister')
    call dein#add('scrooloose/nerdcommenter')
    call dein#add('ctrlpvim/ctrlp.vim')
    call dein#add('vim-airline/vim-airline-themes')
    call dein#add('joshdick/onedark.vim')
    call dein#add('nvim-treesitter/nvim-treesitter', {'hook_post_update': 'TSUpdate'})
    call dein#add('fatih/vim-go')
	call dein#add('neoclide/coc.nvim', { 'merged': 0, 'rev': 'release' })
    call dein#add('antoinemadec/FixCursorHold.nvim')
    call dein#add('justinmk/vim-sneak')
    call dein#add('lambdalisue/fern.vim')
    call dein#add('mileszs/ack.vim')
    call dein#add('lukas-reineke/indent-blankline.nvim')
    call dein#add('windwp/nvim-autopairs')
    if !has('nvim')
      call dein#add('roxma/nvim-yarp')
      call dein#add('roxma/vim-hug-neovim-rpc')
    endif
    call dein#end()
  if (has("termguicolors"))
    set termguicolors
  endif
endif
syntax enable
" set Vim-specific sequences for RGB colors
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
filetype plugin indent on
set splitbelow

colorscheme onedark
let g:airline_theme='onedark'

set splitright
set foldmethod=indent
set foldlevel=99
let mapleader = " "
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
set updatetime=100
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

" Remap VIM 0 to first non-blank character
map 0 ^
set nu
set clipboard=unnamedplus

" fern
nnoremap <C-H> :Fern . -drawer -reveal=% -toggle<CR>

" use ag for ACK
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif

" git blames
function! s:ToggleBlame()
    if &l:filetype ==# 'fugitiveblame'
        close
    else
        Git blame
    endif
endfunction

nnoremap gb :call <SID>ToggleBlame()<CR>
nmap ]h <Plug>(GitGutterNextHunk)
nmap [h <Plug>(GitGutterPrevHunk)

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("nvim-0.5.0") || has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number colmn into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" COC
let g:coc_global_extensions = [
  \ 'coc-go',
  \ 'coc-json',
  \ 'coc-yaml',
  \ 'coc-snippets',
  \ 'coc-prettier',
  \ 'coc-marketplace',
  \ ]



" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
"
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
"
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
"
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
"
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
"
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
"
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
"
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
"
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
"
nmap <leader>qf  <Plug>(coc-fix-current)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
"
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups.
"
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
"
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
"
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
"
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics.
"
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Find symbol of current document.
"
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
"
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Resume latest coc list.
"
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>u


" go
let g:go_def_mapping_enabled = 0
"let g:go_info_mode = "gopls"
"let g:go_def_mode = "gopls"
"let g:go_fillstruct_mode = "gopls"
let g:go_fmt_command = "goimports"
let g:go_fmt_fail_silently = 1
let g:go_list_type = "quickfix" " only use quickfixes

" vim-go quickfix hotkeys
"set autowrite
"autocmd FileType go nnoremap gn :cnext<CR>
"autocmd FileType go nnoremap gp :cprevious<CR>
autocmd FileType go nnoremap <leader>A :cclose<CR>
"autocmd FileType go nnoremap gN :cc<CR>



" go callers
"autocmd FileType go nmap <leader>b :!go build -gcflags="all=-N -l" -tags=rest,static_ui,noauth -o /home/neo/code/scanner/bin/scanner gitlab.etecs.ru/polygon/scanner/cmd/scanner-server<CR>
"autocmd FileType go nmap <leader>r :!go build -gcflags="all=-N -l" -tags=rest,static_ui,noauth -o /home/neo/code/scanner/bin/scanner gitlab.etecs.ru/polygon/scanner/cmd/scanner-server;  /home/neo/code/scanner/bin/scanner
"autocmd FileType go nmap <leader>t <Plug>(go-test)
autocmd FileType go nmap <Leader>l <Plug>(go-metalinter)

" vim-go highlights
let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_operators = 1
let g:go_highlight_extra_types = 1
"let g:go_auto_sameids = 1
let g:go_metalinter_autosave = 0
let g:go_metalinter_autosave_enabled = []
let g:go_metalinter_command = "golangci-lint -c /home/neo/code/scanner/.golangci.yml"
let g:go_metalinter='golangci-lint'
let g:go_metalinter_enabled = []
let g:go_debug = ['shell-commands']

" disable all linters as that is taken care of by coc.nvim
let g:go_diagnostics_enabled = 0

" don't jump to errors after metalinter is invoked
let g:go_jump_to_error = 0

" treesitter, blankline, autopairs setup
let g:indent_blankline_use_treesitter = v:true
let g:indent_blankline_show_current_context = v:true
lua <<EOF
-- TREESITTER
require'nvim-treesitter.configs'.setup {
  -- One of "all", "maintained" (parsers with maintainers), or a list of languages
  ensure_installed = "maintained",

  -- Install languages synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- List of parsers to ignore installing
  ignore_install = { "javascript" },

  highlight = {
    -- `false` will disable the whole extension
    enable = true,

    -- list of language that will be disabled
    disable = { "c", "rust" },

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
  textobjects = { enable = true },
}

-- BLANKILINE
require("indent_blankline").setup {
    -- for example, context is off by default, use this to turn it on
    show_current_context = true,
    show_current_context_start = true,
}

-- AUTOPAIRS
local remap = vim.api.nvim_set_keymap
local npairs = require('nvim-autopairs')

npairs.setup({ 
	check_ts = true,
	map_bs = false, 
	map_cr = false 
})
vim.g.coq_settings = { keymap = { recommended = false } }

-- these mappings are coq recommended mappings unrelated to nvim-autopairs
remap('i', '<esc>', [[pumvisible() ? "<c-e><esc>" : "<esc>"]], { expr = true, noremap = true })
remap('i', '<c-c>', [[pumvisible() ? "<c-e><c-c>" : "<c-c>"]], { expr = true, noremap = true })
remap('i', '<tab>', [[pumvisible() ? "<c-n>" : "<tab>"]], { expr = true, noremap = true })
remap('i', '<s-tab>', [[pumvisible() ? "<c-p>" : "<bs>"]], { expr = true, noremap = true })

-- skip it, if you use another global object
_G.MUtils= {}

MUtils.CR = function()
  if vim.fn.pumvisible() ~= 0 then
    if vim.fn.complete_info({ 'selected' }).selected ~= -1 then
      return npairs.esc('<c-y>')
    else
      return npairs.esc('<c-e>') .. npairs.autopairs_cr()
    end
  else
    return npairs.autopairs_cr()
  end
end
remap('i', '<cr>', 'v:lua.MUtils.CR()', { expr = true, noremap = true })

MUtils.BS = function()
  if vim.fn.pumvisible() ~= 0 and vim.fn.complete_info({ 'mode' }).mode == 'eval' then
    return npairs.esc('<c-e>') .. npairs.autopairs_bs()
  else
    return npairs.autopairs_bs()
  end
end
remap('i', '<bs>', 'v:lua.MUtils.BS()', { expr = true, noremap = true })

local ts_conds = require('nvim-autopairs.ts-conds')
EOF
