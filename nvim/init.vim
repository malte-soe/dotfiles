let g:loaded_python_provider = 1
let g:netrw_dirhistmax = 0
set tabstop=4
set shiftwidth=0
set expandtab
set lazyredraw
set showmatch
set cc=80,100,120
set scrolloff=7
set autoread
set shortmess=I
set scrolljump=10
"
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
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'honza/vim-snippets'
" UI
Plug 'arcticicestudio/nord-vim'
Plug 'sheerun/vim-polyglot'
Plug 'vim-airline/vim-airline'
" Navigation
Plug 'junegunn/fzf', { 'do': './install --bin' }
Plug 'junegunn/fzf.vim'
Plug 'majutsushi/tagbar'
Plug 'christoomey/vim-tmux-navigator'
" GIT
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
" Tools
Plug 'neomake/neomake'
Plug 'rhysd/vim-grammarous'
" Keybindings
Plug 'tpope/vim-vinegar'    " Filemanager
Plug 'tpope/vim-unimpaired' " Bracket navigation
Plug 'tpope/vim-commentary' " Commenting
call plug#end()

" Colorscheme
let g:airline_powerline_fonts = 1
let g:nord_italic_comments = 1
let g:nord_underline = 1
colorscheme nord

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

" Fuzzy file finder
nnoremap <c-p> :FZF<cr>

" Neomake
map <F9> :Neomake!<CR>
let g:neomake_make_maker = {
            \ 'exe': 'make',
            \ }
let g:neomake_markdown_enabled_makers = ['make']

" Tagbar
nmap <F8> :TagbarToggle<CR>

autocmd! bufwritepost init.vim source %
