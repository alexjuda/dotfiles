local common = require("aj.lsp.common")

local M = {}


M.setup = function()
    -- Language server for Sphinx and rst.
    -- Requires `marksman` installed. Get it from
    -- https://github.com/artempyanykh/marksman/releases.

    vim.lsp.config("marksman", {
        on_attach = common.shared_on_attach,
        capabilities = common.make_shared_capabilities(),
    })

    vim.lsp.enable("marksman")
end


return M
