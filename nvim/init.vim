:set tabstop=4
:set shiftwidth=0
:set expandtab
:set number
:set autoindent
filetype plugin indent on

let g:airline#extensions#ale#enabled = 1
let g:ale_fix_on_save = 1
let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'python': ['autopep8', 'add_blank_lines_for_python_control_statements'],
\}

let g:ale_completion_enabled = 1
let g:ale_completion_delay = 1
set completeopt=menu,menuone,preview,noselect,noinsert
let g:ale_linters = {
\  'python': ['pyls'],
\  'rust': ['rls'],
\}

call plug#begin('~/.local/share/nvim/plugged')

Plug 'scrooloose/nerdtree'
Plug 'w0rp/ale'
Plug 'vim-airline/vim-airline'
Plug 'majutsushi/tagbar'

call plug#end()
