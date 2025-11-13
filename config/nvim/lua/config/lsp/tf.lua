-- Language server for terraform.
-- Installation: https://github.com/hashicorp/terraform-ls/blob/main/docs/installation.md
local M = {}

local filetypes = { "terraform" }

local function setup_tf_ls()
    local common = require("config.lsp.common")

    vim.lsp.config("terraform-ls", {
        cmd = { "terraform-ls", "serve" },
        filetypes = filetypes,
        root_markers = { ".git" },
        settings = {},
        on_attach = common.shared_on_attach,
        capabilities = common.shared_make_client_capabilities(),
    })

    vim.lsp.enable("terraform-ls")
end


M.setup = function()
    setup_tf_ls()
end


return M
