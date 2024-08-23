local common = require("aj.lsp.common")

local M = {}


M.setup = function()
    -- Language server for Sphinx and rst.

    require("lspconfig").esbonio.setup {
        on_attach = common.shared_on_attach,
        cmd = { "esbonio", },
    }
end


return M
