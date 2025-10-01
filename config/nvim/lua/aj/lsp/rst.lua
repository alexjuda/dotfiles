local common = require("aj.lsp.common")

local M = {}


M.setup = function()
    -- Language server for Sphinx and rst.

    vim.lsp.config("esbonio", {
        on_attach = common.shared_on_attach,
        cmd = { "esbonio", },
    })

    vim.lsp.enable("esbonio")
end


return M
