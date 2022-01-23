local cmd = vim.cmd -- to execute Vim commands e.g. cmd('pwd')
local fn = vim.fn -- to call Vim functions e.g. fn.bufnr()
local g = vim.g -- a table to access global variables
local opt = vim.opt -- to set options
g.netrw_dirhistmax = 0
g.mapleader = " "
opt.mouse = "a"
opt.shortmess:append("Ic")
opt.cc = { 80, 88, 100 }
opt.scrolloff = 7
opt.incsearch = true
opt.inccommand = "split"
opt.smartcase = true
opt.showmatch = true
opt.signcolumn = "no"
opt.updatetime = 250
opt.splitright = true
opt.lazyredraw = true
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.autoindent = true
opt.copyindent = true
opt.hidden = true

g.tex_flavor = "latex"

cmd([[
    augroup numbertoggle
        autocmd!
        autocmd BufEnter,WinEnter,FocusGained,InsertLeave * set number relativenumber cursorline
        autocmd BufLeave,WinLeave,FocusLost,InsertEnter   * set norelativenumber nocursorline number
    augroup END
]])

-- gui -------------------------------------------------------------------------
vim.opt.guifont = "FiraCode Nerd Font"

-- paq.nvim automatic install --------------------------------------------------
local install_path = fn.stdpath("data") .. "/site/pack/paqs/start/paq-nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	cmd("!git clone --depth=1 https://github.com/savq/paq-nvim.git " .. install_path)
end
local paq = require("paq")
paq({
	"savq/paq-nvim",
	"nvim-lua/plenary.nvim",
	"nvim-lua/popup.nvim",
	-- Linting/Autocomplete/Format
	"neovim/nvim-lspconfig",
	"rafamadriz/friendly-snippets",
	"hrsh7th/vim-vsnip",
	"hrsh7th/nvim-cmp",
	"hrsh7th/cmp-buffer",
	"hrsh7th/cmp-nvim-lua",
	"hrsh7th/cmp-nvim-lsp",
	"hrsh7th/cmp-vsnip",
	"hrsh7th/cmp-path",
	"ray-x/lsp_signature.nvim",
	"nvim-treesitter/nvim-treesitter",
	"nvim-treesitter/nvim-treesitter-refactor",
	"nvim-treesitter/nvim-treesitter-textobjects",
	-- Navigation
	"christoomey/vim-tmux-navigator",
	"nvim-telescope/telescope.nvim",
	-- GIT
	"tpope/vim-fugitive",
	"lewis6991/gitsigns.nvim",
	-- Keybindings
	"tpope/vim-unimpaired",
	"tpope/vim-commentary",
	-- UI
	"projekt0n/github-nvim-theme",
	"kyazdani42/nvim-web-devicons",
	"onsails/lspkind-nvim",
	"nvim-lualine/lualine.nvim",
	-- Preview
	"iamcco/markdown-preview.nvim",
	-- Other stuff
	"brymer-meneses/grammar-guard.nvim",
	"williamboman/nvim-lsp-installer",
})

require("gitsigns").setup({ numhl = true })

-- autocomplete
local cmp = require("cmp")
local lspkind = require("lspkind")
local has_words_before = function()
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local feedkey = function(key, mode)
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

cmp.setup({
	formatting = {
		format = function(entry, vim_item)
			vim_item.kind = lspkind.presets.default[vim_item.kind]
			return vim_item
		end,
	},
	snippet = {
		expand = function(args)
			vim.fn["vsnip#anonymous"](args.body)
		end,
	},
	mapping = {
		["<C-p>"] = cmp.mapping.select_prev_item(),
		["<C-n>"] = cmp.mapping.select_next_item(),
		["<C-d>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.close(),
		["<CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Insert,
		}),
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif vim.fn["vsnip#available"]() == 1 then
				feedkey("<Plug>(vsnip-expand-or-jump)", "")
			elseif has_words_before() then
				cmp.complete()
			else
				fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
			end
		end, { "i", "s" }),

		["<S-Tab>"] = cmp.mapping(function()
			if cmp.visible() then
				cmp.select_prev_item()
			elseif vim.fn["vsnip#jumpable"](-1) == 1 then
				feedkey("<Plug>(vsnip-jump-prev)", "")
			end
		end, { "i", "s" }),
	},
	sources = {
		{ name = "buffer" },
		{ name = "nvim_lsp" },
		{ name = "nvim_lua" },
		{ name = "path" },
		{ name = "vsnip" },
	},
})

require("grammar-guard").init()
local lsp_signature = require("lsp_signature")
local on_attach = function(client, bufnr)
	lsp_signature.on_attach()
end
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)
local lspconfig = require("lspconfig")
local lsps = {
	"bashls",
	"pyright",
	"rls",
	"rnix",
	"sumneko_lua",
	{
		server = "texlab",
		cfg = {
			settings = {
				texlab = {
					build = {
						executable = "tectonic",
						args = { "%f", "--synctex", "--keep-logs", "--keep-intermediates" },
					},
                    forwardSearch = {
                        executable = "zathura",
                        args = {"--synctex-forward", "%l:1:%f", "%p"},
                    },
				},
			},
		},
	},
	{
		server = "clangd",
		cfg = {
			cmd = {
				"clangd",
				"--background-index",
				"--completion-style=detailed",
				"--query-driver=" .. (vim.env.NIX_CC or "/usr") .. "/bin/clang++",
			},
		},
	},
	{
		server = "grammar_guard",
		cfg = {
			cmd = { vim.env.HOME .. "/.local/share/nvim/lsp_servers/ltex/ltex-ls/bin/ltex-ls" },
			settings = {
				ltex = {
					enabled = { "latex", "tex", "bib", "markdown" },
					language = "en-US",
					diagnosticSeverity = "information",
					sentenceCacheSize = 2000,
					additionalRules = {
						enablePickyRules = true,
						motherTongue = "de-DE",
					},
					latex = {
					    environments = {
                            algorithm="ignore",
                        },
                    },
					trace = { server = "verbose" },
				},
			},
		},
	},
}
for _, lsp in ipairs(lsps) do
	if type(lsp) == "string" then
		lsp = { server = lsp, cfg = {} }
	end
	lsp.cfg.on_attach = on_attach
	lsp.cfg.capabilities = capabilities
	lspconfig[lsp.server].setup(lsp.cfg)
end

-- treesitter ------------------------------------------------------------------
require("nvim-treesitter.configs").setup({
	ensure_installed = "maintained",
	highlight = {
		enable = true,
	},
	indent = {
		enable = true,
	},
	refactor = {
		highlight_definitions = {
			enable = true,
		},
	},
	textobjects = {
		select = {
			enable = true,
			lookahead = true,
			keymaps = {
				["af"] = "@function.outer",
				["if"] = "@function.inner",
				["ac"] = "@class.outer",
				["ic"] = "@class.inner",
			},
		},
		swap = {
			enable = true,
			swap_next = {
				["<leader>a"] = "@parameter.inner",
			},
			swap_previous = {
				["<leader>A"] = "@parameter.inner",
			},
		},
		move = {
			enable = true,
			set_jumps = true, -- whether to set jumps in the jumplist
			goto_next_start = {
				["]m"] = "@function.outer",
				["]]"] = "@class.outer",
			},
			goto_next_end = {
				["]M"] = "@function.outer",
				["]["] = "@class.outer",
			},
			goto_previous_start = {
				["[m"] = "@function.outer",
				["[["] = "@class.outer",
			},
			goto_previous_end = {
				["[M"] = "@function.outer",
				["[]"] = "@class.outer",
			},
		},
	},
})

-- telescope -------------------------------------------------------------------
-- see https://github.com/neovim/neovim/pull/13823
cmd([[
nnoremap <leader>i  <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <leader>gd <cmd>lua require'telescope.builtin'.lsp_definitions{}<CR>
nnoremap <leader>gt <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <leader>gi <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <leader>fr <cmd>lua require'telescope.builtin'.lsp_references{}<CR>
nnoremap <leader>fic <cmd>lua vim.lsp.buf.incoming_calls()<CR>
nnoremap <silent>]d <cmd>lua vim.diagnostic.goto_next()<CR>
nnoremap <silent>[d <cmd>lua vim.diagnostic.goto_prev()<CR>

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
require("lualine").setup({
	options = {
		theme = "github",
	},
	sections = {
		lualine_b = {
			"branch",
			"diff",
		},
		lualine_c = {
			{
				"filename",
				path = 1,
			},
			{
				"diagnostics",
				sources = { "nvim_diagnostic" },
			},
		},
	},
	inactive_sections = {
		lualine_a = {
			{
				"filename",
				path = 1,
			},
		},
		lualine_b = {},
		lualine_c = {},
		lualine_z = {},
		lualine_y = {},
	},
})

-- colorscheme --------------------------------------------------------------------
require("github-theme").setup({
	theme_style = "dark_default",
	dark_sidebar = false,
	dark_float = true,
	hide_inactive_statusline = false,
	overrides = function(c)
		return {
			NormalNC = { bg = c.bg2 },
			ColorColumn = {},
		}
	end,
})
cmd([[set fillchars+=vert:\ ]])
