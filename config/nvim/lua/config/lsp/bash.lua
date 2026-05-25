local M = {}

local filetypes = { 'bash', 'sh', 'zsh' }

-- Requires `bash-language-server` npm package.
-- 'npm install -g bash-language-server
local function setup_jsonls()
    local common = require("config.lsp.common")

    vim.lsp.config("bashls", {
        cmd = { 'bash-language-server', 'start' },
        filetypes = filetypes,
        on_attach = common.shared_on_attach,
        capabilities = common.shared_make_client_capabilities(),
    })

    vim.lsp.enable("bashls")
end


M.setup = function()
    setup_jsonls()
end


return M
