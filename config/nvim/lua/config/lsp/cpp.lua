local M = {}

local filetypes = { "c", "cpp", "objc", "objcpp", "cuda" }

-- C++ and other languages from the C family.
-- Installation on Fedora: https://stackoverflow.com/a/71810871
--
-- Inspired by: https://github.com/neovim/nvim-lspconfig/blob/master/lsp/ccls.lua
local function setup_ccls()
    local common = require("config.lsp.common")

    vim.lsp.config("ccls", {
        cmd = { "ccls" },
        filetypes = filetypes,
        on_attach = common.shared_on_attach,
        capabilities = common.shared_make_client_capabilities(),
    })

    vim.lsp.enable("ccls")
end


M.setup = function()
    setup_ccls()
end


return M
