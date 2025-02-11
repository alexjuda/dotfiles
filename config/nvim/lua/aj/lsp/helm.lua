local common = require("aj.lsp.common")

local M = {}


M.setup = function()
    -- Requires installing https://github.com/mrjosh/helm-ls

    require("lspconfig").helm_ls.setup {
        on_attach = common.shared_on_attach,
        cmd = { "helm_ls", "serve", },
        settings = {
            ["helm-ls"] = {
                yamlls = {
                    -- enabled = false,
                    -- cmd = { "npx", "yaml-language-server", "--stdio", },
                },
            },
        },
    }
end


return M
