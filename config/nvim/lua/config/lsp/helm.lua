local M = {}

local filetypes = {"helm"}

local function setup_helmls()
    local common = require("config.lsp.common")
    local switchers = require("config.switchers")

    -- Requires installing https://github.com/mrjosh/helm-ls

    local cmd_name
    if switchers.on_mac() then
        cmd_name = "helm_ls"
    else
        cmd_name = "helm-ls"
    end

    vim.lsp.config("helm_ls", {
        cmd = { cmd_name, "serve", },
        filetypes = filetypes,
        settings = {
            ["helm-ls"] = {
                yamlls = {
                    -- enabled = false,
                    -- cmd = { "npx", "yaml-language-server", "--stdio", },
                },
            },
        },
        on_attach = common.shared_on_attach,
        capabilities = common.shared_make_client_capabilities(),
    })

    vim.lsp.enable("helm_ls")
end


M.setup = function()
    setup_helmls()
end


return M
