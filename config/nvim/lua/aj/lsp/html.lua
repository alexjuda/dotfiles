local common = require("aj.lsp.common")

local M = {}


M.setup = function()
    -- Language server for html, css, and js.
    -- Requires installing https://github.com/hrsh7th/vscode-langservers-extracted

    vim.lsp.config("html", {
        on_attach = common.shared_on_attach,
        cmd = { "npx", "vscode-html-language-server", "--stdio", },
    })

    vim.lsp.enable("html")
end


return M
