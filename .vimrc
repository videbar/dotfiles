" plugins
let need_to_install_plugins = 0
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    let need_to_install_plugins = 1
endif

call plug#begin()
Plug 'arcticicestudio/nord-vim'
Plug 'Valloric/YouCompleteMe'
Plug 'tpope/vim-sensible'
Plug 'itchyny/lightline.vim'
Plug 'joshdick/onedark.vim'
Plug 'airblade/vim-gitgutter'
Plug 'preservim/nerdtree'
Plug 'jistr/vim-nerdtree-tabs'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'preservim/nerdcommenter'
Plug 'jiangmiao/auto-pairs'
Plug 'dense-analysis/ale'
Plug 'majutsushi/tagbar'
Plug 'vim-scripts/indentpython.vim'
Plug 'lepture/vim-jinja'
Plug 'alvan/vim-closetag'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'tpope/vim-fugitive'
Plug 'cespare/vim-toml'
call plug#end()

filetype plugin indent on
syntax on

if need_to_install_plugins == 1
    echo "Installing plugins..."
    silent! PlugInstall
    echo "Done!"
    q
endif

" always show the status bar
set laststatus=2

" highlight the current line
:set cursorline

" control key+d goes to definition                       
"map <C-d> :YcmCompleter GoToDefinitionElseDeclaration<CR> 

let g:ycm_python_binary_path = 'python3'                                                                           
let g:ycm_autoclose_preview_window_after_completion = 1                                                            
let g:ycm_min_num_of_chars_for_completion = 1

" enable 256 colours
set t_Co=256
set t_ut=

" turn on line numbering
set number

" sane text files
set fileformat=unix
set encoding=utf-8
set fileencoding=utf-8

" sane editing
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set viminfo='25,\"50,n~/.viminfo
set colorcolumn=88
autocmd FileType html setlocal tabstop=2 shiftwidth=2 softtabstop=2
autocmd FileType css setlocal tabstop=2 shiftwidth=2 softtabstop=2
autocmd FileType javascript setlocal tabstop=2 shiftwidth=2 softtabstop=2
autocmd FileType yaml setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab

" Keep the cursor centered
function! CentreCursor()
    let pos = getpos(".")
    normal! zz
    call setpos(".", pos)
endfunction

:autocmd CursorMoved,CursorMovedI * call CentreCursor()

" auto-pairs
au FileType python let b:AutoPairs = AutoPairsDefine({"f'" : "'", "r'" : "'", "b'" : "'"})

" map leader key to the space bar
let mapleader = "\<Space>"

" word movement
imap <S-Left> <Esc>bi
nmap <S-Left> b
imap <S-Right> <Esc><Right>wi
nmap <S-Right> w

" toggle spell check with Ctrl-s: https://gist.github.com/brandonpittman/9d15134057c7267a88a8
function! ToggleSpellCheck()
  if &spell
    setlocal nospell
    echo "Spellcheck off"
  else
    setlocal spell spelllang=en_gb
    echo "Spellcheck on"
  endif
endfunction

nnoremap <silent> <C-s> :call ToggleSpellCheck()<CR>

" commenting key bindings
let g:NERDCreateDefaultMappings=1
let g:NERDSpaceDelims = 1
nmap <C-n> <plug>NERDCommenterToggle
vmap <C-n> <Plug>NERDCommenterToggle

" adds a comment at the end of the line
nmap <leader>A <Plug>NERDCommenterAppend

" move between tabs with CTRL - l/h
nnoremap <silent><C-h> :tabprevious<CR>
nnoremap <silent><C-l> :tabnext<CR>

" remove last searched terms with \:
noremap <silent>\ :let @/ = ""<CR>

" mouse
set mouse=a
let g:is_mouse_enabled = 1
noremap <silent> <Leader>m :call ToggleMouse()<CR>
function ToggleMouse()
    if g:is_mouse_enabled == 1
        echo "Mouse OFF"
        set mouse=
        let g:is_mouse_enabled = 0
    else
        echo "Mouse ON"
        set mouse=a
        let g:is_mouse_enabled = 1
    endif
endfunction

" color scheme
syntax on
"colorscheme onedark
colorscheme nord
let g:nord_cursor_line_number_background = 1
filetype on
filetype plugin indent on

 "lightline
set noshowmode
"let g:lightline = { 'colorscheme': 'onedark',
"\ }

let g:lightline = { 
    \ 'colorscheme': 'nord',
    \ 'separator': { 'left': '', 'right': '' },
    \ 'subseparator': { 'left': '', 'right': '' },
    \ 'active': {
        \ 'left': [ 
            \ [ 'mode', 'paste'  ],
            \ [ 'gitbranch', 'readonly', 'filename', 'modified'  ]
        \ ]
    \ },
    \ 'component_function': {
        \ 'gitbranch': 'FugitiveHead'
    \ },
	\ 'mode_map': {
		\ 'n' : 'normal',
        \ 'i' : 'insert',
        \ 'R' : 'replace',
        \ 'v' : 'visual',
        \ 'V' : 'v-line',
        \ "\<C-v>": 'v-block',
        \ 'c' : 'command',
        \ 's' : 'select',
        \ 'S' : 's-line',
        \ "\<C-s>": 's-block',
        \ 't': 'terminal',
	\ },
\ }


" code folding
set foldmethod=indent
set foldlevel=99
nnoremap <leader><leader> za

 "wrap toggle
setlocal nowrap
noremap <silent> <Leader>w :call ToggleWrap()<CR>
function ToggleWrap()
    if &wrap
        echo "Wrap OFF"
        setlocal nowrap
        set virtualedit=all
        silent! nunmap <buffer> <Up>
        silent! nunmap <buffer> <Down>
        silent! nunmap <buffer> <Home>
        silent! nunmap <buffer> <End>
        silent! iunmap <buffer> <Up>
        silent! iunmap <buffer> <Down>
        silent! iunmap <buffer> <Home>
        silent! iunmap <buffer> <End>
    else
        echo "Wrap ON"
        setlocal wrap linebreak nolist
        set virtualedit=
        setlocal display+=lastline
        noremap  <buffer> <silent> <Up>   gk
        noremap  <buffer> <silent> <Down> gj
        noremap  <buffer> <silent> <Home> g<Home>
        noremap  <buffer> <silent> <End>  g<End>
        inoremap <buffer> <silent> <Up>   <C-o>gk
        inoremap <buffer> <silent> <Down> <C-o>gj
        inoremap <buffer> <silent> <Home> <C-o>g<Home>
        inoremap <buffer> <silent> <End>  <C-o>g<End>
    endif
endfunction

" move through split windows
nmap <leader><Up> :wincmd k<CR>
nmap <leader><Down> :wincmd j<CR>
nmap <leader><Left> :wincmd h<CR>
nmap <leader><Right> :wincmd l<CR>

" move through buffers
nmap <leader>[ :bp!<CR>
nmap <leader>] :bn!<CR>
nmap <leader>x :bd<CR>

" restore place in file from previous session
source $VIMRUNTIME/defaults.vim

"set scrolloff=999

" erase searches from previous sessions
autocmd BufReadPre,FileReadPre * :let @/ = ""

" file browser
let NERDTreeIgnore = ['\.pyc$', '__pycache__']
let NERDTreeMinimalUI = 1
let g:nerdtree_open = 0
map <C-t> :call NERDTreeToggle()<CR>
function NERDTreeToggle()
    NERDTreeTabsToggle
    if g:nerdtree_open == 1
        let g:nerdtree_open = 0
    else
        let g:nerdtree_open = 1
        wincmd p
    endif
endfunction

function! StartUp()
    if 0 == argc()
        NERDTree
    end
endfunction
autocmd VimEnter * call StartUp()

" ale
"nmap <C-j> <Plug>(ale_next_wrap)
"nmap <C-k> <Plug>(ale_previous_wrap)

" tags
map <C-b> :TagbarToggle<CR>

" copy, cut and paste
vmap <C-c> "+y
vmap <C-x> "+c
vmap <C-v> c<ESC>"+p
imap <C-v> <ESC>"+pa

" disable autoindent when pasting text
" source: https://coderwall.com/p/if9mda/automatically-set-paste-mode-in-vim-when-pasting-in-insert-mode
let &t_SI .= "\<Esc>[?2004h"
let &t_EI .= "\<Esc>[?2004l"

function! XTermPasteBegin()
    set pastetoggle=<Esc>[201~
    set paste
    return ""
endfunction

inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()

