local nvim_lsp = require'nvim_lsp'
local diagnostic = require('diagnostic')
local lsp_status = require('lsp-status')
lsp_status.register_progress()
lsp_status.config({
    status_symbol = "",
})

local custom_attach = function(client)
    diagnostic.on_attach(client)
    lsp_status.on_attach(client)
end


nvim_lsp.pyls.setup{
    on_attach = custom_attach,
    capabilities = lsp_status.capabilities,
    settings={
        pyls = {
            plugins= {
                pycodestyle = {
                    maxLineLength = 88;
                },
                pyls_mypy = {
                    enabled = true,
                    live_mode = true,
                }
            }
        }
    }
}

nvim_lsp.vimls.setup({
    on_attach = custom_attach,
})

nvim_lsp.sumneko_lua.setup{
    on_attach = custom_attach,
    capabilities = lsp_status.capabilities,
}

nvim_lsp.rls.setup{}

nvim_lsp.texlab.setup{}
