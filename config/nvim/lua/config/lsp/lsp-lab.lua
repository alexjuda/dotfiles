-- lsp-lab is my own project where I experiment with LSP server implementations.
local M = {}

M.setup = function()
    local common = require("config.lsp.common")

    vim.lsp.config("lsp-lab", {
        cmd = { "lsp-lab" },
        filetypes = {"python"},
        settings = {},
        on_attach = function(client, buf_n)
            common.shared_on_attach(client, buf_n)
        end,
        capabilities = common.shared_make_client_capabilities(),
    })

    vim.lsp.enable("lsp-lab")
end

return M
