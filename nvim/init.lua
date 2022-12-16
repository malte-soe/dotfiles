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
    nnoremap <leader>w  <cmd>update<CR>
    nnoremap <leader>q  <cmd>quit<CR>
]])

-- gui -------------------------------------------------------------------------
vim.opt.guifont = "FiraCode Nerd Font"

-- packer.nvim -----------------------------------------------------------------
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
    packer_bootstrap = fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
    -- vim.cmd [[packadd packer.nvim]]
end

require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'
    use {
        'github/copilot.vim',
        config = function()
            vim.g.copilot_no_tab_map = true
            vim.api.nvim_set_keymap("i", "<C-J>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
        end,
    }
    use {
        'jose-elias-alvarez/null-ls.nvim',
        requires = {
            'nvim-lua/plenary.nvim'
        },
        config = function()
            null_ls = require("null-ls")
            null_ls.setup({
                sources = {
                    null_ls.builtins.formatting.isort,
                    null_ls.builtins.formatting.black,
                },
            })
        end,
    }
    use {
        "nvim-neotest/neotest",
        requires = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            "antoinemadec/FixCursorHold.nvim",
            "nvim-neotest/neotest-python"
        },
        config = function()
            require("neotest").setup({
                adapters = {
                    require("neotest-python"),
                },
            })
        end,
    }
    use { 
        'rcarriga/nvim-dap-ui', 
        requires = {
            'mfussenegger/nvim-dap',
            'mfussenegger/nvim-dap-python'
        }, 
        config = function()
            require("dapui").setup()    
            local dap, dapui = require("dap"), require("dapui")
            dap.listeners.after.event_initialized["dapui_config"] = function()
              dapui.open()
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
              dapui.close()
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
              dapui.close()
            end
            vim.keymap.set('n', '<leader>dc', require('dap').continue)
            vim.keymap.set('n', '<leader>di', require('dap').step_into)
            vim.keymap.set('n', '<leader>do', require('dap').step_over)
            vim.keymap.set('n', '<leader>dl', require('dap').run_last)
            vim.keymap.set('n', '<leader>db', require('dap').toggle_breakpoint)
            vim.keymap.set('n', '<leader>dr', require('dap').repl.open)
            vim.keymap.set('n', '<leader>dtm', require('dap-python').test_method)
            vim.keymap.set('n', '<leader>dtc', require('dap-python').test_class)
            vim.keymap.set('v', '<leader>ds', require('dap-python').debug_selection)
        end,
    }
    use {
        'mfussenegger/nvim-dap-python',
        config = function()
            require('dap-python').setup('$HOME/miniconda3/envs/ldm/bin/python')
        end,
    }
    use 'christoomey/vim-tmux-navigator'
    use 'tpope/vim-unimpaired'
    use 'tpope/vim-commentary'
    use 'tpope/vim-fugitive'
    use {
        'lewis6991/gitsigns.nvim',
        config = function() require("gitsigns").setup({ numhl = true }) end
    }
    use {
        'hrsh7th/nvim-cmp',
        requires = {
            'neovim/nvim-lspconfig',
            'hrsh7th/vim-vsnip',
            'rafamadriz/friendly-snippets',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-nvim-lua',
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-vsnip',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-nvim-lsp-signature-help',
            'onsails/lspkind-nvim',
        },
        config = function()
            local cmp = require('cmp')
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
                    { name = "cmp-nvim-lsp-signature-help" },
                },
            })
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
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
                                    args = { "--synctex-forward", "%l:1:%f", "%p" },
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
            }
            for _, lsp in ipairs(lsps) do
                if type(lsp) == "string" then
                    lsp = { server = lsp, cfg = {} }
                end
                lsp.cfg.on_attach = on_attach
                lsp.cfg.capabilities = capabilities
                lspconfig[lsp.server].setup(lsp.cfg)
            end

        end
    }

    use {
        'nvim-treesitter/nvim-treesitter',
        requires = {
            'nvim-treesitter/nvim-treesitter-refactor',
            'nvim-treesitter/nvim-treesitter-textobjects',
            'nvim-treesitter/nvim-treesitter-context',
        },
        run = function() require('nvim-treesitter.install').update({ with_sync = true }) end,
        config = function()
            require("nvim-treesitter.configs").setup({
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
        end
    }

    use {
        'nvim-telescope/telescope.nvim',
        branch = '0.1.x',
        requires = {
            'nvim-telescope/telescope-file-browser.nvim',
            'nvim-lua/plenary.nvim',
        },
        config = function()
            local telescope = require("telescope")
            local builtin = require("telescope.builtin")
            telescope.setup()
            telescope.load_extension "file_browser"
            vim.keymap.set("n", "<leader>fb", telescope.extensions.file_browser.file_browser, { noremap = true })
            vim.keymap.set("n", "<leader>ft", builtin.current_buffer_fuzzy_find, { noremap = true })
            vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { noremap = true })
            vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, { noremap = true })
            -- TODO use vim.keymap
            vim.cmd([[
            nnoremap <leader>i  <cmd>lua vim.lsp.buf.hover()<CR>
            nnoremap <leader>gd <cmd>lua require'telescope.builtin'.lsp_definitions{}<CR>
            nnoremap <leader>gt <cmd>lua vim.lsp.buf.type_definition()<CR>
            nnoremap <leader>gi <cmd>lua vim.lsp.buf.implementation()<CR>
            nnoremap <leader>fr <cmd>lua require'telescope.builtin'.lsp_references{}<CR>
            nnoremap <leader>fic <cmd>lua vim.lsp.buf.incoming_calls()<CR>
            nnoremap <silent>]d <cmd>lua vim.diagnostic.goto_next()<CR>
            nnoremap <silent>[d <cmd>lua vim.diagnostic.goto_prev()<CR>

            nnoremap <leader>r  <cmd>lua vim.lsp.buf.rename()<CR>
            nnoremap <leader>fg <cmd>lua require'telescope.builtin'.live_grep{}<CR>
            nnoremap <leader>fws <cmd>lua require'telescope.builtin'.lsp_dynamic_workspace_symbols{}<CR>
            nnoremap <leader>fds <cmd>lua require'telescope.builtin'.lsp_document_symbols{}<CR>
            nnoremap <leader>ff <cmd>lua require'telescope.builtin'.find_files()<CR>
            nnoremap <leader>b <cmd>lua require'telescope.builtin'.buffers()<CR>
            nnoremap <leader>fl <cmd>lua require'telescope.builtin'.grep_string{search=vim.fn.expand("%:t"), use_regex=false}<CR>
            nnoremap <leader>w  <cmd>update<CR>
            nnoremap <leader>q  <cmd>quit<CR>

            nnoremap <leader>cc <cmd>ClangdSwitchSourceHeader<CR>
            ]])
        end,
    }

    use {
        'nvim-lualine/lualine.nvim',
        requires = {
            'kyazdani42/nvim-web-devicons',
        },
        config = function()
            require("lualine").setup({
                options = {
                    theme = "auto",
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
        end,
        after = "github-nvim-theme",
    }

    use {
        'projekt0n/github-nvim-theme',
        config = function()
            require("github-theme").setup({
                theme_style = "dark_default",
                dark_sidebar = false,
                dark_float = true,
                overrides = function(c)
                    return {
                        NormalNC = { bg = c.bg2 },
                        ColorColumn = {},
                    }
                end,
            })
            vim.cmd([[set fillchars+=vert:\ ]])
            vim.keymap.set("n", "<leader>cd", ":colorscheme github_dark_default<CR>", { noremap = true })
            vim.keymap.set("n", "<leader>cl", ":colorscheme github_light_default<CR>", { noremap = true })
        end
    }

    if packer_bootstrap then
        require('packer').sync()
    end
end)
