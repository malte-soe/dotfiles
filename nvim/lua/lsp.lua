local lspconfig = require'lspconfig'
local lsp_status = require('lsp-status')
lsp_status.register_progress()
lsp_status.config({
    status_symbol = "",
})

lspconfig.pyls.setup{
    on_attach = lsp_status.on_attach,
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

lspconfig.sumneko_lua.setup{
    on_attach = lsp_status.on_attach,
    capabilities = lsp_status.capabilities,
}

lspconfig.rls.setup{}

lspconfig.texlab.setup{}

lspconfig.rnix.setup{}
