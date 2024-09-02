local common = require("aj.lsp.common")

local M = {}


-- Infers the full executable path based on shell command name
local read_exec_path = function(exec_name)
    local handle = io.popen("which " .. exec_name)
    local result = handle:read("*a"):gsub("\n", "")
    handle:close()
    return result
end


local setup_pyright = function()
    -- Requires ``pyright`` installed via npm.
    require("lspconfig").pyright.setup {
        settings = {
            python = {
                -- Use the locally available python executable. Enables using pyright from an activated venv.
                pythonPath = read_exec_path("python"),
            },
        },
        on_attach = function(client, buf_n)
            common.shared_on_attach(client, buf_n)

            -- print("pyright server caps")
            -- print(vim.inspect(client.server_capabilities))
        end,
        capabilities = common.make_shared_capabilities(),
    }
end

local setup_pylsp = function()
    -- Requires `python-lsp-server` pip package.
    require("lspconfig").pylsp.setup {
        settings = {
            pylsp = {
                configurationSources = { "flake8" },
            },
        },
        on_attach = function(client, buf_n)
            common.shared_on_attach(client, buf_n)

            -- print("pylsp server caps")
            -- print(vim.inspect(client.server_capabilities))
            --
            -- Already handled by pyright
            client.server_capabilities.completionProvider = nil
            client.server_capabilities.definitionProvider = nil
            client.server_capabilities.hoverProvider = nil
            client.server_capabilities.referencesProvider = nil
            client.server_capabilities.renameProvider = nil
            client.server_capabilities.signatureHelpProvider = nil
        end,
        capabilities = common.make_shared_capabilities(),
    }
end


M.setup = function()
    setup_pylsp()
    setup_pyright()
end


return M
