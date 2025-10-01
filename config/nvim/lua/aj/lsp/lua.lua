local common = require("aj.lsp.common")

local M = {}


M.setup = function()
    -- Requires `lua-language-server` available at PATH.
    vim.lsp.config("lua_ls", {
        settings = {
            Lua = {
                runtime = {
                    -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of neovim)
                    version = 'LuaJIT',
                },
                diagnostics = {
                    -- Get the language server to recognize the `vim` global
                    globals = { 'vim' },
                },
                workspace = {
                    -- Make the server aware of neovim runtime files
                    library = vim.api.nvim_get_runtime_file("", true),
                },
                -- Do not send telemetry data containing a randomized but unique identifier
                telemetry = {
                    enable = false,
                },
            },
        },
        on_attach = common.shared_on_attach,
        capabilities = common.make_shared_capabilities(),
    })

    vim.lsp.enable("lua_ls")
end


return M
