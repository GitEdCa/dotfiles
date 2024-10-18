local lsp_config = require('lsp_config')

local function setup_lsp()
    -- Check if the LSP is available
    local lsp = vim.lsp
    local lspconfig = {
        cmd = { "clangd", "--background-index" },  -- Specify the command to start clangd
        on_attach = lsp_config.on_attach,
    }

    -- Start the language server
    lsp.start({
        name = "clangd",
        cmd = lspconfig.cmd,
        on_attach = lspconfig.on_attach,
    })
end

-- Call the setup function when a C++ file is opened
setup_lsp()

-- Optionally set up diagnostics
vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    update_in_insert = false,
    underline = true,
    severity_sort = true,
})
