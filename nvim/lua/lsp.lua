local nvim_lsp = require'nvim_lsp'
require'lsp-status'.register_progress()
nvim_lsp.pyls.setup{
    settings={
        pyls = {
            plugins= {
                pycodestyle = {
                    maxLineLength = 88;
                }
            }
        }
    }
}

nvim_lsp.vimls.setup{}

nvim_lsp.sumneko_lua.setup{}

nvim_lsp.rls.setup{}

nvim_lsp.texlab.setup{}

