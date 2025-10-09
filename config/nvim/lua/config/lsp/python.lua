local M = {}

local function setup_pyright()
    local common = require("config.lsp.common")

    vim.lsp.config("pyright", {
        cmd = { "pyright-langserver", "--stdio" },
        filetypes = {"python"},
        settings = {
            python = {
                -- Use the locally available python executable. Enables using pyright from an activated venv.
                pythonPath = common.read_exec_path("python"),
            },
        },
        on_attach = function(client, buf_n)
            common.shared_on_attach(client, buf_n)

            -- Already handled by ruff
            client.server_capabilities.formattingProvider = nil
        end,
        capabilities = common.shared_make_client_capabilities(),
    })

    vim.lsp.enable("pyright")
end


local function setup_pylsp()
    local common = require("config.lsp.common")

    -- Requires `python-lsp-server` pip package.
    vim.lsp.config("pylsp", {
        cmd = { "pylsp" },
        filetypes = { "python" },
        settings = {
            pylsp = {
                configurationSources = { "flake8" },
            },
        },
        on_attach = function(client, buf_n)
            common.shared_on_attach(client, buf_n)

            -- We're in a LSP connection callback.
            -- The Language Server told us what functionalities it supports,
            -- and it's 'client.server_capabilities'

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

            -- Already handled by ruff
            client.server_capabilities.formattingProvider = nil
        end,
        capabilities = common.shared_make_client_capabilities(),
    })

    vim.lsp.enable("pylsp")
end

local function setup_ruff()
    local common = require("config.lsp.common")

    vim.lsp.config("ruff", {
        cmd = { "ruff", "server" },
        filetypes = { "python" },
        on_attach = function(client, buf_n)
            common.shared_on_attach(client, buf_n)
        end,
        capabilities = common.shared_make_client_capabilities(),
    })

    vim.lsp.enable("ruff")
end

M.setup = function()
    setup_pyright()
    setup_pylsp()
    setup_ruff()
end


return M
