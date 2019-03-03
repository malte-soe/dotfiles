set tabstop=4
set shiftwidth=0
set expandtab
set number
set cursorline
set lazyredraw
set showmatch
set cc=80,100,120

" Plugins
call plug#begin('~/.local/share/nvim/plugged')
Plug 'chriskempson/base16-vim'
Plug 'sheerun/vim-polyglot'
Plug 'scrooloose/nerdtree'
Plug 'w0rp/ale'
Plug 'vim-airline/vim-airline'
Plug 'majutsushi/tagbar'
Plug 'ctrlpvim/ctrlp.vim'
call plug#end()

" Colorscheme
set termguicolors
colorscheme base16-bright
hi Normal guibg=NONE ctermbg=NONE

" ALE
let g:airline#extensions#ale#enabled = 1
let g:ale_fix_on_save = 1
let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'python': ['autopep8', 'add_blank_lines_for_python_control_statements'],
\}
let g:ale_completion_enabled = 1
let g:ale_completion_delay = 500
set completeopt=menu,menuone,preview,noselect,noinsert
let g:ale_linters = {
\  'python': ['pyls'],
\  'rust': ['rls'],
\}
let g:ale_rust_rls_toolchain = 'stable'

" CtrlP
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'

" NERDTree
map <C-n> :NERDTreeToggle<CR>
