local common = require("aj.lsp.common")

local M = {}

local cmd_name
if common.on_mac() then
    cmd_name = "helm_ls"
else
    cmd_name = "helm-ls"
end

M.setup = function()
    -- Requires installing https://github.com/mrjosh/helm-ls

    require("lspconfig").helm_ls.setup {
        on_attach = common.shared_on_attach,
        cmd = { cmd_name, "serve", },
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
