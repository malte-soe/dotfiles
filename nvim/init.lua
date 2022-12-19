vim.g.netrw_dirhistmax = 0
vim.g.mapleader = " "
vim.o.mouse = "a"
vim.opt.shortmess:append("Ic")
vim.opt.cc = { 80, 88, 100 }
vim.opt.scrolloff = 7
vim.opt.incsearch = true
vim.opt.inccommand = "split"
vim.opt.smartcase = true
vim.opt.showmatch = true
vim.opt.signcolumn = "no"
vim.opt.updatetime = 200
vim.opt.splitright = true
vim.opt.lazyredraw = true
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.copyindent = true
vim.opt.hidden = true

vim.g.tex_flavor = "latex"

vim.cmd([[
    augroup numbertoggle
        autocmd!
        autocmd BufEnter,WinEnter,FocusGained,InsertLeave * set number relativenumber cursorline
        autocmd BufLeave,WinLeave,FocusLost,InsertEnter   * set norelativenumber nocursorline number
    augroup END
    nnoremap <leader>w  <cmd>update<CR>
    nnoremap <leader>q  <cmd>quit<CR>
]])

vim.keymap.set("n", "<leader>w", vim.cmd.update)
vim.keymap.set("n", "<leader>q", vim.cmd.quit)

-- packer.nvim -----------------------------------------------------------------
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
local packer_bootstrap = false
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    packer_bootstrap = true
    vim.fn.execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
    vim.cmd [[packadd packer.nvim]]
end

require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'
    use 'tpope/vim-sleuth'
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
            local null_ls = require("null-ls")
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
            'rafamadriz/friendly-snippets',
            'L3MON4D3/LuaSnip',
            'saadparwaiz1/cmp_luasnip',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-nvim-lua',
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-vsnip',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-nvim-lsp-signature-help',
            'onsails/lspkind-nvim',
        },
        config = function()
            local on_attach = function(_, bufnr)
                local nmap = function(keys, func, desc)
                    if desc then
                        desc = 'LSP: ' .. desc
                    end

                    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
                end

                local builtin = require("telescope.builtin")

                nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
                nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

                nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
                nmap('gr', builtin.lsp_references, '[G]oto [R]eferences')
                nmap('gi', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
                nmap('<leader>td', vim.lsp.buf.type_definition, 'Type [D]efinition')
                nmap('<leader>ds', builtin.lsp_document_symbols, '[D]ocument [S]ymbols')
                nmap('<leader>ws', builtin.lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
                nmap("<leader>f", vim.lsp.buf.format, '[F]ormat')

                -- See `:help K` for why this keymap
                nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
                nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

                -- Lesser used LSP functionality
                nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
                nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
                nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
                nmap('<leader>wl', function()
                    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                end, '[W]orkspace [L]ist Folders')

                -- Create a command `:Format` local to the LSP buffer
                vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
                    vim.lsp.buf.format()
                end, { desc = 'Format current buffer with LSP' })
            end
            require("luasnip.loaders.from_vscode").lazy_load()
            local cmp = require('cmp')
            local lspkind = require("lspkind")
            local luasnip = require("luasnip")
            cmp.setup({
                formatting = {
                    format = function(_, vim_item)
                        vim_item.kind = lspkind.presets.default[vim_item.kind]
                        return vim_item
                    end,
                },
                snippet = {
                    expand = function(args)
                        vim.fn["vsnip#anonymous"](args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert {
                    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<CR>'] = cmp.mapping.confirm {
                        behavior = cmp.ConfirmBehavior.Replace,
                        select = true,
                    },
                    ['<Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                    ['<S-Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                },
                sources = {
                    { name = "buffer" },
                    { name = "nvim_lsp" },
                    { name = "nvim_lua" },
                    { name = "path" },
                    { name = "luasnip" },
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
            vim.keymap.set("n", "<leader>fb", telescope.extensions.file_browser.file_browser)
            vim.keymap.set("n", "<leader>ft", builtin.current_buffer_fuzzy_find)
            vim.keymap.set("n", "<silent>]d", vim.diagnostic.goto_next)
            vim.keymap.set("n", "<silent>[d", vim.diagnostic.goto_prev)
            vim.keymap.set("n", "<leader>fg", builtin.live_grep)
            vim.keymap.set("n", "<leader>ff", builtin.find_files)
            vim.keymap.set("n", "<leader>b", builtin.buffers)
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

-- Automatically source and re-compile packer whenever you save this init.lua
local packer_group = vim.api.nvim_create_augroup('Packer', { clear = true })
vim.api.nvim_create_autocmd('BufWritePost', {
    command = 'source <afile> | PackerCompile',
    group = packer_group,
    pattern = vim.fn.expand '$MYVIMRC',
})
