local cmd = vim.cmd  -- to execute Vim commands e.g. cmd('pwd')
local fn = vim.fn    -- to call Vim functions e.g. fn.bufnr()
local g = vim.g      -- a table to access global variables
local opt = vim.opt  -- to set options
g.netrw_dirhistmax = 0
g.mapleader = " "
opt.mouse = "a"
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
local paq = require 'paq'
paq {
	'savq/paq-nvim';
	'nvim-lua/plenary.nvim';
	'nvim-lua/popup.nvim';
    -- Linting/Autocomplete/Format
	'neovim/nvim-lspconfig';
	'hrsh7th/nvim-compe';
	'ray-x/lsp_signature.nvim';
	'hrsh7th/vim-vsnip';
	'rafamadriz/friendly-snippets';
    'nvim-treesitter/nvim-treesitter';
	'nvim-treesitter/nvim-treesitter-refactor';
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
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = {
    'documentation',
    'detail',
    'additionalTextEdits',
  }
}
local on_attach = function(client, bufnr)
    require'lsp_signature'.on_attach()
end
local lsps = { 
    'bashls',
    'pyright', 
    'rls', 
    'rnix', 
    'sumneko_lua', 
    'texlab', 
    {
        server='clangd', 
        cfg={
            cmd = { 
                "clangd", 
                "--background-index" , 
                "--query-driver", (vim.env.NIX_CC or "/usr") .. "/bin/clang++"
            }
        }
    },
    -- {
    --     server='pyls',
    --     cfg={
    --         settings={
    --             pyls = {
    --                 plugins = {
    --                     pycodestyle = {
    --                         maxLineLength =88;
    --                     },
    --                 },
    --             },
    --         },
    --     },
    -- },
}
for _, lsp in ipairs(lsps) do
    if type(lsp) == 'string' then
        lsp = {server=lsp, cfg={}}
    end
    lsp.cfg.on_attach = on_attach
    lsp.cfg.capabilities = capabilities
    lspconfig[lsp.server].setup(lsp.cfg)
end

vim.o.completeopt = "menuone,noselect"
require'compe'.setup {
    source = {
        path = true;
        buffer = true;
        nvim_lsp = true;
        nvim_lua = true;
        vsnip = true;
    };
}

vim.cmd[[
inoremap <silent><expr> <C-Space> compe#complete()
inoremap <silent><expr> <CR>      compe#confirm('<CR>')
inoremap <silent><expr> <C-e>     compe#close('<C-e>')
inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })
]]

local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
    local col = vim.fn.col('.') - 1
    return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
end

-- Use (s-)tab to:
--- move to prev/next item in completion menuone
--- jump to prev/next snippet's placeholder
_G.tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-n>"
  elseif vim.fn['vsnip#available'](1) == 1 then
    return t "<Plug>(vsnip-expand-or-jump)"
  elseif check_back_space() then
    return t "<Tab>"
  else
    return vim.fn['compe#complete']()
  end
end
_G.s_tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-p>"
  elseif vim.fn['vsnip#jumpable'](-1) == 1 then
    return t "<Plug>(vsnip-jump-prev)"
  else
    -- If <S-Tab> is not working in your terminal, change it to <C-h>
    return t "<S-Tab>"
  end
end

vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})



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
nnoremap <leader>fic <cmd>lua vim.lsp.buf.incoming_calls()<CR>
nnoremap <silent>]d <cmd>lua vim.lsp.diagnostic.goto_next()<CR>
nnoremap <silent>[d <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>

nnoremap <leader>ca <cmd>lua require'telescope.builtin'.lsp_code_actions{}<CR>
nnoremap <leader>f  <cmd>lua vim.lsp.buf.formatting()<CR>
nnoremap <leader>r  <cmd>lua vim.lsp.buf.rename()<CR>
nnoremap <leader>fg <cmd>lua require'telescope.builtin'.live_grep{}<CR>
nnoremap <leader>fws <cmd>lua require'telescope.builtin'.lsp_dynamic_workspace_symbols{}<CR>
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
