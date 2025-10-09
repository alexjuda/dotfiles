local M = {}

local filetypes = { "lua" }

local function setup_luals()
    local common = require("config.lsp.common")

    -- Requires `lua-language-server` available at PATH.
    vim.lsp.config("lua_ls", {
        cmd = { "lua-language-server" },
        filetypes = filetypes,
        root_markers = { ".git" },
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
        capabilities = common.shared_make_client_capabilities(),
    })

    vim.lsp.enable("lua_ls")
end


M.setup = function()
    setup_luals()
end


return M
