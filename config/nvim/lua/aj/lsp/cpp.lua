local common = require("aj.lsp.common")

local M = {}


M.setup = function()
    -- C++ and other languages from the C family.
    -- Installation on Fedora: https://stackoverflow.com/a/71810871

    vim.lsp.config("ccls", {
        on_attach = common.shared_on_attach,
        -- Add cuda to the default filetypes list.
        filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
    })

    vim.lsp.enable("ccls")
end


return M
