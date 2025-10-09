local M = {}

local filetypes = {"html"}

-- Language server for html, css, and js.
-- Requires installing https://github.com/hrsh7th/vscode-langservers-extracted
local function setup_html()
    local common = require("config.lsp.common")

    vim.lsp.config("html", {
        cmd = { "npx", "vscode-html-language-server", "--stdio", },
        filetypes = filetypes,
        on_attach = common.shared_on_attach,
        capabilities = common.shared_make_client_capabilities(),
        -- Inspired by: https://github.com/neovim/nvim-lspconfig/blob/master/lsp/html.lua . Don't know if it's
        -- needed or useful.
        init_options = {
            provideFormatter = true,
            embeddedLanguages = { css = true, javascript = true },
            configurationSection = { 'html', 'css', 'javascript' },
        },
    })

    vim.lsp.enable("ccls")
end

M.setup = function()
    setup_html()
end


return M
