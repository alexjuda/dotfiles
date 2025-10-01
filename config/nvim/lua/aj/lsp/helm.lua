local common = require("aj.lsp.common")
local switchers = require("aj.switchers")

local M = {}

M.setup = function()
    -- Requires installing https://github.com/mrjosh/helm-ls

    local cmd_name
    if switchers.on_mac() then
        cmd_name = "helm_ls"
    else
        cmd_name = "helm-ls"
    end

    vim.lsp.config("helm_ls", {
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
    })

    vim.lsp.enable("helm_ls")
end


return M
