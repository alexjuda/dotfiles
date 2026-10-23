local M = {}

local filetypes = { "make", }

-- Installation:
-- go install github.com/owenrumney/make-ls/cmd/make-ls@latest
local function setup_makels()
    local common = require("config.lsp.common")

    vim.lsp.config("make-ls", {
        cmd = { "make-ls", },
        filetypes = filetypes,
        on_attach = common.shared_on_attach,
        capabilities = common.shared_make_client_capabilities(),
    })

    vim.lsp.enable("make-ls")
end

M.setup = function()
    setup_makels()
end


return M
