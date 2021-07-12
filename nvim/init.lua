local cmd = vim.cmd  -- to execute Vim commands e.g. cmd('pwd')
local fn = vim.fn    -- to call Vim functions e.g. fn.bufnr()
local g = vim.g      -- a table to access global variables
local opt = vim.opt  -- to set options
g.netrw_dirhistmax = 0
g.mapleader = " "
opt.shortmess:append("Ic")
opt.cc = {80,88,100}
opt.scrolloff=7
opt.incsearch = true
opt.inccommand = 'split'
opt.smartcase = true
opt.showmatch = true
opt.signcolumn = 'number'
opt.updatetime = 300
opt.splitright = true
opt.lazyredraw = true
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.autoindent = true
opt.copyindent = true
opt.hidden = true

cmd([[
    augroup numbertoggle
        autocmd!
        autocmd BufEnter,WinEnter,FocusGained,InsertLeave * set relativenumber cursorline
        autocmd BufLeave,WinLeave,FocusLost,InsertEnter   * set norelativenumber nocursorline number
    augroup END
    augroup filetypedetect
        au! BufRead,BufNewFile *.nix setfiletype nix
        au! BufRead,BufNewFile *.fish setfiletype fish
    augroup end

]])

-- paq.nvim automatic install --------------------------------------------------
local install_path = fn.stdpath('data') .. '/site/pack/paqs/start/paq-nvim'
if fn.empty(fn.glob(install_path)) > 0 then
    cmd('!git clone --depth=1 https://github.com/savq/paq-nvim.git ' .. install_path)
end
local paq = require 'paq-nvim'
paq {
	'savq/paq-nvim';
	'nvim-lua/plenary.nvim';
	'nvim-lua/popup.nvim';
    -- Linting/Autocomplete/Format
	'neovim/nvim-lspconfig';
	'hrsh7th/nvim-compe';
	'nvim-lua/lsp-status.nvim';
    'nvim-treesitter/nvim-treesitter';
	'nvim-treesitter/nvim-treesitter-refactor';
	'ray-x/lsp_signature.nvim';
    -- Navigation
	'christoomey/vim-tmux-navigator';
	'nvim-telescope/telescope.nvim';
    -- GIT
	'tpope/vim-fugitive';
	'airblade/vim-gitgutter';
    -- Keybindings
	'tpope/vim-unimpaired';
	'tpope/vim-commentary';
    -- UI
	'bluz71/vim-moonfly-colors';
	'kyazdani42/nvim-web-devicons';
	'hoob3rt/lualine.nvim';
}
paq.clean()
paq.install()

-- colorscheme -----------------------------------------------------------------
cmd([[
set termguicolors
colorscheme moonfly
set fillchars+=vert:\ 
]])
cmd([[
autocmd ColorScheme * highlight clear ColorColumn
autocmd ColorScheme * highlight VertSplit guibg=none
autocmd ColorScheme * highlight StatusLine guibg=none
autocmd ColorScheme * highlight StatusLineNC guibg=none
autocmd ColorScheme * highlight ActiveWindow guibg=#000000
autocmd ColorScheme * set winhighlight=Normal:ActiveWindow,NormalNC:InactiveWindow
]])

-- autocomplete
local lspconfig = require'lspconfig'
local lsp_status = require('lsp-status')
lsp_status.register_progress()
-- lspconfig.pyls.setup{
--     settings={
--         pyls = {
--             plugins= {
--                 pycodestyle = {
--                     maxLineLength = 88;
--                 },
--             }
--         }
--     }
-- }
lspconfig.pyright.setup{}
lspconfig.sumneko_lua.setup{}
lspconfig.rls.setup{}
lspconfig.texlab.setup{}
lspconfig.rnix.setup{}
lspconfig.clangd.setup{
    cmd = { 
        "clangd", 
        "--background-index" , 
        "--query-driver", (vim.env.NIX_CC or "/usr") .. "/bin/clang++"
    },
}

vim.o.completeopt = "menuone,noselect"
require'compe'.setup {
    source = {
        path = true;
        buffer = true;
        nvim_lsp = true;
        nvim_lua = true;
    };
}

require'lsp_signature'.on_attach()

-- treesitter ------------------------------------------------------------------
require'nvim-treesitter.configs'.setup {
    ensure_installed = "maintained",
    highlight = {
        enable = true,
    },
    refactor = {
        highlight_definitions = { 
            enable = true 
        },
    },
    indent = {
        enable = true
    },
}

-- telescope -------------------------------------------------------------------
-- see https://github.com/neovim/neovim/pull/13823
cmd([[
nnoremap <leader>i  <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <leader>gd <cmd>lua require'telescope.builtin'.lsp_definitions{}<CR>
nnoremap <leader>gt <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <leader>gi <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <leader>fr <cmd>lua require'telescope.builtin'.lsp_references{}<CR>
nnoremap <silent>]d <cmd>lua vim.lsp.diagnostic.goto_next()<CR>
nnoremap <silent>[d <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>

nnoremap <leader>ca <cmd>lua require'telescope.builtin'.lsp_code_actions{}<CR>
nnoremap <leader>f  <cmd>lua vim.lsp.buf.formatting_sync(nil, 1000)<CR>
nnoremap <leader>r  <cmd>lua vim.lsp.buf.rename()<CR>
nnoremap <leader>fg <cmd>lua require'telescope.builtin'.live_grep{}<CR>
nnoremap <leader>fws <cmd>lua require'telescope.builtin'.lsp_workspace_symbols{query=vim.fn.input("Query symbol: ")}<CR>
nnoremap <leader>fds <cmd>lua require'telescope.builtin'.lsp_document_symbols{}<CR>
nnoremap <leader>ff <cmd>lua require'telescope.builtin'.find_files()<CR>
nnoremap <leader>fb <cmd>lua require'telescope.builtin'.buffers()<CR>
nnoremap <leader>fl <cmd>lua require'telescope.builtin'.grep_string{search=vim.fn.expand("%:t"), use_regex=false}<CR>
nnoremap <leader>w  <cmd>update<CR>
nnoremap <leader>q  <cmd>quit<CR>

nnoremap <leader>cc <cmd>ClangdSwitchSourceHeader<CR>
]])

-- statusline ------------------------------------------------------------------
require'lualine'.setup{
    options = {theme = 'auto'},
    sections = {
        lualine_a = {
            'mode',
            {
                'diagnostics',
                sources={'nvim_lsp'},
            },
        },
    },
}
