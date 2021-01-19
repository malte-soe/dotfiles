let g:netrw_dirhistmax = 0
let mapleader = " "
set cc=80,88,100
set scrolloff=7
set shortmess+=Ic
set incsearch
set inccommand=split
set smartcase
set showmatch
set signcolumn=number
set updatetime=300
set wrap linebreak
set splitright

set tabstop=4       " number of visual spaces per TAB
set softtabstop=4   " number of spaces in tab when editing
set shiftwidth=4    " number of spaces to use for autoindent
set expandtab       " tabs are space
set autoindent
set copyindent      " copy indent from the previous line

au BufRead,BufNewFile *.nix set filetype=nix


" hyprid number with auto toggling
set number relativenumber cursorline
augroup numbertoggle
    autocmd!
    autocmd BufEnter,WinEnter,FocusGained,InsertLeave * set relativenumber cursorline
    autocmd BufLeave,WinLeave,FocusLost,InsertEnter   * set norelativenumber nocursorline number
augroup END


" Plugins
" Load vim-plug
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
    silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
                \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
call plug#begin('~/.local/share/nvim/plugged')
Plug 'nvim-lua/plenary.nvim'
Plug 'direnv/direnv.vim'
" Linting/Autocomplete/Format
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/completion-nvim'
Plug 'aca/completion-tabnine', { 'do': 'version=3.1.9 ./install.sh' }
Plug 'nvim-lua/lsp-status.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/nvim-treesitter-refactor'
" Navigation
Plug 'christoomey/vim-tmux-navigator'
Plug 'tpope/vim-projectionist'
Plug 'vimwiki/vimwiki', { 'for': 'markdown' }
Plug 'nvim-telescope/telescope.nvim'
" GIT
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
" Keybindings
Plug 'tpope/vim-unimpaired' " Bracket navigation
Plug 'tpope/vim-commentary'
" UI
Plug 'bluz71/vim-moonfly-colors'
Plug 'nvim-lua/popup.nvim'
Plug 'junegunn/goyo.vim', { 'for': ['markdown', 'tex'] }
call plug#end()


" Colorscheme
set termguicolors
colorscheme moonfly
highlight clear ColorColumn
highlight VertSplit guibg=none
set fillchars+=vert:\ 
highlight StatusLine guibg=none
highlight StatusLineNC guibg=none
highlight ActiveWindow guibg=#000000
set winhighlight=Normal:ActiveWindow,NormalNC:InactiveWindow
highlight LspDiagnosticsVirtualTextError guifg=#ff5454 " red
highlight LspDiagnosticsVirtualTextWarning guifg=#80a0ff " blue
highlight LspDiagnosticsVirtualTextInformation guifg=#8cc85f " green



" Load configs written in lua
lua require("lsp")
lua require("treesitter")


autocmd BufEnter * lua require'completion'.on_attach()


" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Set completeopt to have a better completion experience
set completeopt=menuone,noinsert,noselect

let g:completion_chain_complete_list = {
    \ 'default': [
    \    {'complete_items': ['lsp', 'snippet', 'tabnine']},
    \    {'mode': '<c-p>'},
    \    {'mode': '<c-n>'}
    \]
\}
let g:completion_sorting = "none"


" Commands and shortcuts
command Declaration :lua vim.lsp.buf.declaration()
command Definition :lua vim.lsp.buf.definition()
command Hover :lua vim.lsp.buf.hover()
command Implementation :lua vim.lsp.buf.implementation()
command SignatureHelp :lua vim.lsp.buf.signature_help()
command TypeDefinition :lua vim.lsp.buf.type_definition()
command References :lua require'telescope.builtin'.lsp_references{}
command DocumentSymbol :lua vim.lsp.buf.document_symbol()
command WorkspaceSymbol :lua vim.lsp.buf.workspace_symbol()
command Format :lua vim.lsp.buf.formatting_sync(nil, 1000)
command Rename :lua vim.lsp.buf.rename()

nnoremap <silent>K  <cmd>Hover<CR>
nnoremap <silent>gd <cmd>Definition<CR>
nnoremap <silent>gy <cmd>TypeDefinition<CR>
nnoremap <silent>gi <cmd>Implementation<CR>
nnoremap <silent>gr <cmd>References<CR>
nnoremap <silent>]d <cmd>lua vim.lsp.diagnostic.goto_next()<CR>
nnoremap <silent>[d <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>

nnoremap <leader>f  <cmd>Format<CR>
nnoremap <leader>r  <cmd>Rename<CR>
nnoremap <leader>p  <cmd>lua require'telescope.builtin'.git_files{}<CR>
nnoremap <leader>ws <cmd>lua require'telescope.builtin'.lsp_workspace_symbols{}<CR>
nnoremap <leader>ds <cmd>lua require'telescope.builtin'.lsp_document_symbols{}<CR>
nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<CR>
nnoremap <leader>w  <cmd>update<CR>
nnoremap <leader>q  <cmd>quit<CR>


" Terminal navigation
tnoremap <Esc> <C-\><C-n>


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
nnoremap <leader>sz <cmd>lua require'telescope.builtin'.find_files{ cwd = vim.api.nvim_get_var("zettelkasten") }<CR>


" Statusline
function! LspStatus() abort
    return luaeval("require('lsp-status').status()")
endfunction

set statusline=
set statusline+=%{pathshorten(expand('%:~:.'))}     " path
set statusline+=%-4(\ %m%)
set statusline+=\ %y\                               " filetype
set statusline+=%{LspStatus()}                      " language server status
set statusline+=%=
set statusline+=%-4c                                " column
set statusline+=%-4P                                " position


autocmd! bufwritepost init.vim source %
