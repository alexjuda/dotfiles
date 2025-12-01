local M = {}

local filetypes = { "go", }

-- Installation:
-- go install golang.org/x/tools/gopls@latest
local function setup_gopls()

    local common = require("config.lsp.common")

    vim.lsp.config("gopls", {
        cmd = { "gopls", },
        filetypes = filetypes,
        on_attach = common.shared_on_attach,
        capabilities = common.shared_make_client_capabilities(),
    })

    vim.lsp.enable("gopls")
end

M.setup = function()
    setup_gopls()
end


return M
