local common = require("lsp2.common")

local M = {}


M.setup = function()
    -- Language server for Sphinx and rst.
    -- Requires `marksman` installed. Get it from
    -- https://github.com/artempyanykh/marksman/releases.

    require("lspconfig").marksman.setup {
        on_attach = common.shared_on_attach,
        capabilities = common.shared_capabilities,
    }
end


return M
