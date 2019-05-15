let g:loaded_python_provider = 1
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

" Plugins
" Load vim-plug
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
    silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
                \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
call plug#begin('~/.local/share/nvim/plugged')
" Linting/Autocomplete/Format
Plug 'neoclide/coc.nvim', {'do': './install.sh nightly'}
Plug 'honza/vim-snippets'
Plug 'sbdchd/neoformat'
" UI
Plug 'NLKNguyen/papercolor-theme'
Plug 'sheerun/vim-polyglot'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" Navigation
Plug 'ctrlpvim/ctrlp.vim'
Plug 'scrooloose/nerdtree'
Plug 'majutsushi/tagbar'
Plug 'christoomey/vim-tmux-navigator'
Plug 'rhysd/vim-grammarous'
" GIT
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
" Tools
Plug 'neomake/neomake'
" Keybindings
Plug 'tpope/vim-unimpaired'
call plug#end()

" Colorscheme
set termguicolors
let base16colorspace=256
colorscheme PaperColor
let g:airline_powerline_fonts = 1
let g:airline_theme='papercolor'

" Format
let g:neoformat_run_all_formatters = 1
let g:neoformat_python_black = {
            \ 'exe': 'black',
            \ 'stdin': 1,
            \ 'args': ['--line-length 80', '-q', '-'],
            \ }
let g:neoformat_enabled_python = ['black', 'isort']
let g:neoformat_basic_format_align = 1
let g:neoformat_basic_format_retab = 1
let g:neoformat_basic_format_trim = 1
augroup format
    autocmd!
    autocmd BufWritePre * undojoin | Neoformat
augroup END

" LanguageServer
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

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
