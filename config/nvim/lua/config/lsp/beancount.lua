local M = {}

local filetypes = { "bean", "beancount", }

-- The TypeScript implementation. https://github.com/fengkx/beancount-lsp. Feature-rich, but seems unpolished.
local function setup_fengkx_lsp()
    local common = require("config.lsp.common")

    vim.lsp.config("beancount-lsp", {
        cmd = { "beancount-lsp-server", "--stdio", },
        filetypes = filetypes,
        on_attach = common.shared_on_attach,
        capabilities = common.shared_make_client_capabilities(),
    })

    vim.lsp.enable("beancount-lsp")
end

-- The Rust implementation. https://github.com/polarmutex/beancount-language-server. Not as feature-rich, but at least
-- it works!
local function setup_polarmutex_lsp()
    local common = require("config.lsp.common")

    vim.lsp.config("beancount-language-server", {
        cmd = { "beancount-language-server", "--stdio", },
        filetypes = filetypes,
        on_attach = common.shared_on_attach,
        capabilities = common.shared_make_client_capabilities(),
    })

    vim.lsp.enable("beancount-language-server")
end


M.setup = function()
    -- setup_bc_lsp_server()
    setup_polarmutex_lsp()
end


return M
