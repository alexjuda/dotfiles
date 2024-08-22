local common = require("lsp2.common")

local M = {}


M.setup = function()
    -- Language server for html, css, and js.
    -- Requires installing https://github.com/hrsh7th/vscode-langservers-extracted

    require("lspconfig").html.setup {
        on_attach = common.shared_on_attach,
        cmd = { "npx", "vscode-html-language-server", "--stdio", },
    }
end


return M
