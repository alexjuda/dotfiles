local M = {}

local filetypes = { 'json', 'jsonc' }

-- Requires `vscode-langservers-extracted` npm package.
-- 'npm install -g vscode-langservers-extracted
local function setup_jsonls()
    local common = require("config.lsp.common")

    vim.lsp.config("jsonls", {
        cmd = { 'vscode-json-language-server', '--stdio' },
        filetypes = filetypes,
        init_options = {
            provideFormatter = true,
        },
        on_attach = common.shared_on_attach,
        capabilities = common.shared_make_client_capabilities(),
        commands = {
            -- add support for full buffer formatting using range formatting
            Format = {
                function()
                    vim.lsp.buf.range_formatting({}, { 0, 0 }, { vim.fn.line("$"), 0 })
                end
            },
        },
    })

    vim.lsp.enable("jsonls")
end


M.setup = function()
    local common = require("config.lsp.common")
    common.register_lsp_aucmd("JSONLSPSetup", filetypes, function()
        setup_jsonls()
    end)
end


return M
