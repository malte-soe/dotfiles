set tabstop=4
set shiftwidth=0
set expandtab
set lazyredraw
set showmatch
set cc=80,100,120
set scrolloff=7
set clipboard=unnamed

" hyprid number with auto toggling
set number relativenumber cursorline

augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber cursorline
  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber nocursorline
augroup END

augroup fixers
  autocmd!
  " Remove trailing spaces
  autocmd FileType c,cpp,java,php,python autocmd BufWritePre <buffer> %s/\s\+$//e
  " Remove trailing blank lines
  autocmd BufWritePre * %s/\($\n\s*\)\+\%$//e
augroup END

" Plugins
" Load vim-plug
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
    silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
call plug#begin('~/.local/share/nvim/plugged')
" Linting/Autocomplete
"Plug 'w0rp/ale'
Plug 'neoclide/coc.nvim', {'do': './install.sh nightly'}
Plug 'honza/vim-snippets'
" UI
Plug 'sheerun/vim-polyglot'
Plug 'chriskempson/base16-vim'
Plug 'vim-airline/vim-airline'
" Navigation
Plug 'ctrlpvim/ctrlp.vim'
Plug 'scrooloose/nerdtree'
Plug 'majutsushi/tagbar'
Plug 'christoomey/vim-tmux-navigator'
Plug 'rhysd/vim-grammarous'
" GIT
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
call plug#end()

" Colorscheme
"set termguicolors
"colorscheme base16-default-dark

" Snippets
inoremap <silent><expr> <TAB>
      \ pumvisible() ? coc#_select_confirm() :
      \ coc#expandableOrJumpable() ? coc#rpc#request('doKeymap', ['snippets-expand-jump','']) :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

let g:coc_snippet_next = '<tab>'

" Docstring
let g:snips_author = 'Malte Sönnichsen'
let g:snips_github = 'https://github.com/Chacki'
let g:snips_email = 'chacki@users.noreply.github.com'

" LanguageTool
let g:grammarous#languagetool_cmd = 'languagetool-commandline'

" ALE
"let g:airline#extensions#ale#enabled = 1
"let g:ale_fix_on_save = 1
"let g:ale_fixers = {
"\   '*': ['remove_trailing_lines', 'trim_whitespace'],
"\   'python': ['black', 'add_blank_lines_for_python_control_statements', 'isort'],
"\}
"let g:ale_completion_enabled = 1
"let g:ale_completion_delay = 500
"set completeopt=menu,menuone,preview,noselect,noinsert
"let g:ale_linters = {
"\  'python': ['pyls'],
"\  'rust': ['rls'],
"\}
"let g:ale_python_black_options = '--line-length 79'
"let g:ale_rust_rls_toolchain = 'stable'
"
"map <c-[> :ALEGoToDefinitionInTab<CR>

" CtrlP
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'

" Neomake
map <F9> :Neomake!<CR>
let g:neomake_make_maker = {
    \ 'exe': 'make',
    \ }
let g:neomake_markdown_enabled_makers = ['make']

" NERDTree
map <F7> :NERDTreeToggle<CR>

" Tagbar
nmap <F8> :TagbarToggle<CR>

autocmd! bufwritepost init.vim source %
