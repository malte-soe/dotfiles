let g:loaded_python_provider = 1
let g:netrw_dirhistmax = 0
let mapleader = " "
set autoread
set cc=80,88,100
set expandtab
set incsearch
set lazyredraw
set scrolljump=10
set scrolloff=7
set shiftwidth=0
set shortmess+=Ic
set showmatch
set signcolumn=yes
set tabstop=4
set updatetime=300

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
Plug 'jeffkreeftmeijer/vim-dim'
Plug 'sheerun/vim-polyglot'
" Navigation
Plug 'liuchengxu/vim-clap', { 'do': ':Clap install-binary' }
Plug 'christoomey/vim-tmux-navigator'
Plug 'tpope/vim-projectionist'
" GIT
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
" Keybindings
Plug 'tpope/vim-vinegar'    " Filemanager
Plug 'tpope/vim-unimpaired' " Bracket navigation
Plug 'tpope/vim-commentary' " Commenting
call plug#end()

" Colorscheme
colorscheme dim
highlight clear SignColumn
highlight clear ColorColumn

" Docstring
let g:snips_author = 'Malte Sönnichsen'
let g:snips_github = 'https://github.com/malte-soe'
let g:snips_email = 'chacki@users.noreply.github.com'

" Fuzzy file finder
nnoremap <c-p> :Clap<cr>



" COC
" use <tab> for trigger completion and navigate to the next complete item
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <Tab>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Docs
nnoremap <silent> D :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Refactoring
nmap <leader>rn <Plug>(coc-rename)
" Remap for do codeAction of selected region
function! s:cocActionsOpenFromSelected(type) abort
  execute 'CocCommand actions.open ' . a:type
endfunction
xmap <silent> <leader>a :<C-u>execute 'CocCommand actions.open ' . visualmode()<CR>
nmap <silent> <leader>a :<C-u>set operatorfunc=<SID>cocActionsOpenFromSelected<CR>g@

" Use <TAB> for selections ranges.
" NOTE: Requires 'textDocument/selectionRange' support from the language server.
" coc-tsserver, coc-python are the examples of servers that support it.
nmap <silent> <TAB> <Plug>(coc-range-select)
xmap <silent> <TAB> <Plug>(coc-range-select)

" Statusline
hi StatuslineColor ctermbg=None ctermfg=blue
set statusline=
set statusline+=%#StatuslineColor#
set statusline+=%f
set statusline+=%=
set statusline+=%{coc#status()}
set statusline+=%y              " file type
set statusline+=%10((%l,%c)%)\            " line and column
set statusline+=%P                        " percentage of file



autocmd! bufwritepost init.vim source %
