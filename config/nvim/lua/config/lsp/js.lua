local M = {}

local filetypes = { "javascript", "typescript", }

-- Requires `typescript` and `typescript-language-server` packages. If they're not installed locally, it will fetch them
-- each time. Anyway, installing:
-- npm install -g typescript typescript-language-server
local function setup_ts_ls()
    local common = require("config.lsp.common")

    vim.lsp.config("ts_ls", {
        cmd = { "npx", "typescript-language-server", "--stdio", },
        filetypes = filetypes,
        on_attach = common.shared_on_attach,
        capabilities = common.shared_make_client_capabilities(),
    })

    vim.lsp.enable("ts_ls")
end

M.setup = function()
    setup_ts_ls()
end


return M
