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
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)

-- lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "--single-branch",
        "https://github.com/folke/lazy.nvim.git",
        lazypath,
    })
end
vim.opt.runtimepath:prepend(lazypath)

require("lazy").setup({
    "tpope/vim-sleuth", -- automatically adjust 'shiftwidth' and 'expandtab'
    {
        "sourcegraph/sg.nvim",
        dependencies = { 
            "nvim-lua/plenary.nvim", 
            "nvim-telescope/telescope.nvim"
        },
        config = function()
            require("sg").setup()
        end,
    },
    {
        "nvim-neotest/neotest",
        keys = {
            {
                "<leader>tn",
                function()
                    require("neotest").run.run()
                end,
            },
            {
                "<leader>ts",
                function()
                    require("neotest").summary.toggle()
                end,
            },
            {
                "<leader>tm",
                function()
                    require("neotest").summary.run_marked()
                end,
            },
        },
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            "antoinemadec/FixCursorHold.nvim",
            "nvim-neotest/neotest-python",
        },
        config = function()
            require("neotest").setup({
                adapters = {
                    require("neotest-python"),
                },
            })
        end,
    },
    {
        "rcarriga/nvim-dap-ui",
        keys = {
            {
                "<leader>dc",
                function()
                    require("dap").continue({})
                end,
            },
            {
                "<leader>di",
                function()
                    require("dap").step_into({})
                end,
            },
            {
                "<leader>do",
                function()
                    require("dap").step_over({})
                end,
            },
            {
                "<leader>dl",
                function()
                    require("dap").run_last({})
                end,
            },
            {
                "<leader>db",
                function()
                    require("dap").toggle_breakpoint({})
                end,
            },
            {
                "<leader>dr",
                function()
                    require("dap").repl.open({})
                end,
            },
            {
                "<leader>dtm",
                function()
                    require("dap-python").test_method({})
                end,
            },
            {
                "<leader>dtc",
                function()
                    require("dap-python").test_class({})
                end,
            },
            {
                "<leader>ds",
                function()
                    require("dap-python").debug_selection({})
                end,
            },
        },
        dependencies = {
            "mfussenegger/nvim-dap",
            "mfussenegger/nvim-dap-python",
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
        end,
    },
    {
        "mfussenegger/nvim-dap-python",
        config = function()
            require("dap-python").setup()
        end,
    },
    {
        "mrjones2014/smart-splits.nvim",
        config = function()
            require("smart-splits").setup()
            -- recommended mappings
            -- resizing splits
            vim.keymap.set("n", "<A-h>", require("smart-splits").resize_left)
            vim.keymap.set("n", "<A-j>", require("smart-splits").resize_down)
            vim.keymap.set("n", "<A-k>", require("smart-splits").resize_up)
            vim.keymap.set("n", "<A-l>", require("smart-splits").resize_right)
            -- moving between splits
            vim.keymap.set("n", "<C-h>", require("smart-splits").move_cursor_left)
            vim.keymap.set("n", "<C-j>", require("smart-splits").move_cursor_down)
            vim.keymap.set("n", "<C-k>", require("smart-splits").move_cursor_up)
            vim.keymap.set("n", "<C-l>", require("smart-splits").move_cursor_right)
            -- swapping buffers between windows
            vim.keymap.set("n", "<leader><leader>h", require("smart-splits").swap_buf_left)
            vim.keymap.set("n", "<leader><leader>j", require("smart-splits").swap_buf_down)
            vim.keymap.set("n", "<leader><leader>k", require("smart-splits").swap_buf_up)
            vim.keymap.set("n", "<leader><leader>l", require("smart-splits").swap_buf_right)
        end,
    },
    "tpope/vim-unimpaired",
    {
        "numToStr/Comment.nvim",
        config = function()
            require('Comment').setup()
        end,
    },
    "tpope/vim-fugitive",
    {
        "lewis6991/gitsigns.nvim",
        config = function()
            require("gitsigns").setup({ numhl = true })
        end,
    },
    {
        "zbirenbaum/copilot.lua",
        config = function()
            require("copilot").setup()
        end,
    },
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "neovim/nvim-lspconfig",
            "rafamadriz/friendly-snippets",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-nvim-lua",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-nvim-lsp-signature-help",
            "onsails/lspkind-nvim",
            "nvim-telescope/telescope.nvim",
            "zbirenbaum/copilot.lua",
            "zbirenbaum/copilot-cmp",
        },
        config = function()
            local on_attach = function(_, bufnr)
                local map = function(keys, func, desc, mode)
                    if desc then
                        desc = "LSP: " .. desc
                    end
                    vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = desc })
                end
                local nmap = function(keys, func, desc)
                    map(keys, func, desc, "n")
                end
                local vmap = function(keys, func, desc)
                    map(keys, func, desc, "v")
                end

                local builtin = require("telescope.builtin")

                nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
                nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
                vmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

                nmap("gd", builtin.lsp_definitions, "[G]oto [D]efinition")
                nmap("gr", builtin.lsp_references, "[G]oto [R]eferences")
                nmap("gi", builtin.lsp_implementations, "[G]oto [I]mplementation")
                nmap("<leader>td", builtin.lsp_type_definitions, "[T]ype [D]efinition")
                nmap("<leader>ds", builtin.lsp_document_symbols, "[D]ocument [S]ymbols")
                nmap("<leader>ws", builtin.lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
                nmap("F", vim.lsp.buf.format, "[F]ormat")

                -- See `:help K` for why this keymap
                nmap("K", vim.lsp.buf.hover, "Hover Documentation")

                -- Lesser used LSP functionality
                nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
                nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
                nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
                nmap("<leader>wl", function()
                    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                end, "[W]orkspace [L]ist Folders")

                -- Create a command `:Format` local to the LSP buffer
                vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
                    vim.lsp.buf.format()
                end, { desc = "Format current buffer with LSP" })
            end
            require("luasnip.loaders.from_vscode").lazy_load()
            require("copilot_cmp").setup()
            local cmp = require("cmp")
            local lspkind = require("lspkind")
            lspkind.init({
                symbol_map = { Copilot = "" },
            })
            local luasnip = require("luasnip")
            cmp.setup({
                formatting = {
                    format = lspkind.cmp_format({
                        with_text = false,
                        maxwidth = 50,
                    }),
                },
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<CR>"] = cmp.mapping.confirm({
                        behavior = cmp.ConfirmBehavior.Replace,
                        select = true,
                    }),
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                }),
                sources = {
                    { name = "buffer" },
                    { name = "nvim_lsp" },
                    { name = "nvim_lua" },
                    { name = "path" },
                    { name = "luasnip" },
                    { name = "nvim_lsp_signature_help" },
                    { name = "copilot" },
                },
            })
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
            local lspconfig = require("lspconfig")
            local lsps = {
                "bashls",
                "pyright",
                "ruff_lsp",
                "rust_analyzer",
                "tailwindcss",
                {
                    server = "volar",
                    cfg = {
                        filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue", "json" },
                    },
                },
                "tsserver",
                "nil_ls",
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
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter",
        dependencies = {
            "nvim-treesitter/nvim-treesitter-refactor",
            "nvim-treesitter/nvim-treesitter-textobjects",
            "nvim-treesitter/nvim-treesitter-context",
        },
        run = function()
            require("nvim-treesitter.install").update({ with_sync = true })
        end,
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = {
                    "lua",
                    "python",
                    "nix",
                    "bash",
                    "typescript",
                    "javascript",
                    "rust",
                    "vue",
                    "json",
                    "latex",
                },
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
        end,
    },
    {
        "nvim-telescope/telescope.nvim",
        keys = {
            { "<leader>ft", "<cmd>Telescope current_buffer_fuzzy_find<cr>" },
            { "<leader>fg", "<cmd>Telescope live_grep<cr>" },
            { "<leader>ff", "<cmd>Telescope find_files<cr>" },
            { "<leader>b", "<cmd>Telescope buffers<cr>" },
            { "<leader>fb", "<cmd>Telescope file_browser<cr>" },
            { "<leader>u", "<cmd>Telescope undo<cr>" },
        },
        config = function()
            local telescope = require("telescope")
            telescope.setup({
                extensions = {
                },
            })
            telescope.load_extension("file_browser")
            telescope.load_extension("undo")
        end,
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope-file-browser.nvim",
            "debugloop/telescope-undo.nvim",
        },
    },
    {
        "nvim-lualine/lualine.nvim",
        dependencies = {
            "kyazdani42/nvim-web-devicons",
            "projekt0n/github-nvim-theme",
        },
        config = function()
            require("lualine").setup({
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
    },
    {
        "projekt0n/github-nvim-theme",
        lazy = false, -- make sure we load this during startup if it is your main colorscheme
        priority = 1000, -- make sure to load this before all the other start plugins
        config = function()
            require('github-theme').setup({
                dim_inactive = true,      -- Non focused panes set to alternative background
            })
            vim.cmd("colorscheme github_dark_default")
        end,
    }
}, {
})
