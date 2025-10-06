local M = {}

local filetypes = { "markdown" }

-- Requires `marksman` installed. Get it from
-- https://github.com/artempyanykh/marksman/releases.
local function setup_marksman()
    local common = require("config.lsp.common")
    vim.lsp.config("marksman", {
        cmd = { "marksman", "server", },
        filetypes = filetypes,
        on_attach = common.shared_on_attach,
        capabilities = common.shared_make_client_capabilities(),
    })

    vim.lsp.enable("marksman")
end


M.setup = function()
    local common = require("config.lsp.common")
    common.register_lsp_aucmd("MarkdownLSPSetup", filetypes, function()
        setup_marksman()
    end)
end


return M
