let g:netrw_dirhistmax = 0
let mapleader = " "
set cc=80,88,100
set expandtab
set scrolljump=10
set scrolloff=7
set shiftwidth=0
set shortmess+=Ic
set incsearch
set inccommand=split
set smartcase
set showmatch
set signcolumn=yes
set tabstop=4
set updatetime=300
set wrap linebreak


" hyprid number with auto toggling
set number relativenumber cursorline
augroup numbertoggle
    autocmd!
    autocmd BufEnter,WinEnter,FocusGained,InsertLeave * set relativenumber cursorline
    autocmd BufLeave,WinLeave,FocusLost,InsertEnter   * set norelativenumber nocursorline
augroup END


" Plugins
" Load vim-plug
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
    silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
                \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
call plug#begin()
" Linting/Autocomplete/Format
Plug 'neovim/nvim-lsp'
Plug 'nvim-lua/completion-nvim'
Plug 'nvim-lua/diagnostic-nvim'
Plug 'nvim-lua/lsp-status.nvim'
Plug 'nvim-treesitter/nvim-treesitter'
" Navigation
Plug 'christoomey/vim-tmux-navigator'
Plug 'tpope/vim-projectionist'
Plug 'vimwiki/vimwiki'
" GIT
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
" Keybindings
Plug 'tpope/vim-vinegar'    " Filemanager
Plug 'tpope/vim-unimpaired' " Bracket navigation
Plug 'tpope/vim-commentary' " Commenting
" UI
Plug 'jeffkreeftmeijer/vim-dim'
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-lua/telescope.nvim'
call plug#end()

" Load configs written in lua
lua require("lsp")
lua require("treesitter")


autocmd BufEnter * lua require'completion'.on_attach()
autocmd BufEnter * lua require'diagnostic'.on_attach()
let g:diagnostic_enable_virtual_text = 1
let g:diagnostic_virtual_text_prefix = ' '


" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Set completeopt to have a better completion experience
set completeopt=menuone,noinsert,noselect


" Commands and shortcuts
command Declaration :lua vim.lsp.buf.declaration()
command Definition :lua vim.lsp.buf.definition()
command Hover :lua vim.lsp.buf.hover()
command Implementation :lua vim.lsp.buf.implementation()
command SignatureHelp :lua vim.lsp.buf.signature_help()
command TypeDefinition :lua vim.lsp.buf.type_definition()
command References :lua vim.lsp.buf.references()
command DocumentSymbol :lua vim.lsp.buf.document_symbol()
command WorkspaceSymbol :lua vim.lsp.buf.workspace_symbol()
command Format :lua vim.lsp.buf.formatting_sync(nil, 1000)

nnoremap <silent>K  <cmd>Hover<CR>
nnoremap <silent>gd <cmd>Definition<CR>
nnoremap <silent>gy <cmd>TypeDefinition<CR>
nnoremap <silent>gi <cmd>Implementation<CR>
nnoremap <silent>gr <cmd>lua require'telescope.builtin'.lsp_references{}<CR>
nnoremap <silent>[d <cmd>PrevDiagnosticCycle<CR>
nnoremap <silent>]d <cmd>NextDiagnosticCycle<CR>

nnoremap <leader>f <cmd>Format<CR>
nnoremap <leader>p <cmd>lua require'telescope.builtin'.git_files{}<CR>
nnoremap <leader>w <cmd>update<CR>
nnoremap <leader>q <cmd>quit<CR>


" Colorscheme
colorscheme dim
highlight SignColumn ctermbg=none
highlight clear ColorColumn
set fillchars+=vert:\ 
highlight StatusLineNC ctermbg=none ctermfg=grey
highlight StatusLine ctermbg=none ctermfg=blue

highlight LspDiagnosticsError ctermfg=red
highlight LspDiagnosticsWarning ctermfg=yellow
highlight LspDiagnosticsHint ctermfg=blue


" Zettelkasten
let g:zettelkasten = '~/Zettelkasten/'
let g:vimwiki_list =[{
            \ 'path': zettelkasten,
            \ 'syntax': 'markdown',
            \ 'ext': '.md'
            \ }]
let g:vimwiki_global_ext = 0
command! -nargs=1 NewZettel :execute ":e" zettelkasten . strftime("%Y%m%d%H%M") . "-<args>.md"
nnoremap <leader>nz :NewZettel 


" Statusline
function! LspStatus() abort
  if luaeval('#vim.lsp.buf_get_clients() > 0')
    return luaeval("require('lsp-status').status()")
  endif

  return ''
endfunction

set statusline=
set statusline+=%{pathshorten(expand('%:~:.'))}     " path
set statusline+=%-4(\ %m%)
set statusline+=\ %y\                                " filetype
set statusline+=%{LspStatus()}                      " language server status
set statusline+=%=
set statusline+=%-4c                               " column
set statusline+=%-4P                               " position


autocmd! bufwritepost init.vim source %
