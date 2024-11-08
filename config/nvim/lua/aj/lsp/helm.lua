local common = require("aj.lsp.common")

local M = {}


M.setup = function()
    -- Requires installing https://github.com/mrjosh/helm-ls

    require("lspconfig").helm_ls.setup {
        on_attach = common.shared_on_attach,
        cmd = { "helm-ls", "serve", },
    }
end


return M
