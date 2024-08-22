local common = require("lsp2.common")

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
        end,
        capabilities = common.shared_capabilities,
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

            -- Disable capabilities already covered by pyright.
            -- Based on https://neovim.discourse.group/t/how-to-config-multiple-lsp-for-document-hover/3093/2
            --
            -- Seems to work around buggy autocomplete behavior, where the symbol disappears after hitting <CR>.
            client.server_capabilities.hoverProvider = false
            client.server_capabilities.completionProvider = nil
            -- Workaround for duplicated "new symbol name" prompts.
            client.server_capabilities.renameProvider = false
        end,
        capabilities = common.shared_capabilities,
    }
end


M.setup = function()
    setup_pylsp()
    setup_pyright()
end


return M
