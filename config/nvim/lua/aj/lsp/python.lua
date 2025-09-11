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
    require("lspconfig").pyright.setup {
        cmd = { "pyright-langserver", "--stdio" },
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
            --
            -- Already handled by ruff
            client.server_capabilities.formattingProvider = nil
        end,
        capabilities = common.make_shared_capabilities(),
    }
end

local setup_pylsp = function()
    -- Requires `python-lsp-server` pip package.
    require("lspconfig").pylsp.setup {
        cmd = {
            "pylsp",
        },
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
        capabilities = common.make_shared_capabilities(),
    }
end

local setup_ruff = function()
    require("lspconfig").ruff.setup {
        cmd = { "ruff", "server" },
        on_attach = function(client, buf_n)
            common.shared_on_attach(client, buf_n)
        end,
        capabilities = common.make_shared_capabilities(),
    }
end

local setup_dap = function()
    local dap = require("dap")
    local dapui = require("dapui")

    -- Setup dap-ui
    dapui.setup()

    -- Setup python adapter
    require("dap-python").setup("python") -- you can pass path to venv python

    -- Open dap-ui automatically
    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
      dapui.close()
    end

    vim.keymap.set("n", "<F5>", function() require("dap").continue() end)
    vim.keymap.set("n", "<F10>", function() require("dap").step_over() end)
    vim.keymap.set("n", "<F11>", function() require("dap").step_into() end)
    vim.keymap.set("n", "<F12>", function() require("dap").step_out() end)
    vim.keymap.set("n", "<leader>db", function() require("dap").toggle_breakpoint() end)
    vim.keymap.set("n", "<leader>dB", function()
      require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
    end)
    vim.keymap.set("n", "<leader>dr", function() require("dap").repl.open() end)


    -- Pytest configuration
    require("dap-python").test_runner = "pytest"

    -- Debug the test under cursor
    vim.keymap.set("n", "<leader>dn", function()
      require("dap-python").test_method()
    end)

    -- Debug the current file’s tests
    vim.keymap.set("n", "<leader>df", function()
      require("dap-python").test_class()
    end)

    -- Debug the whole file
    vim.keymap.set("n", "<leader>ds", function()
      require("dap-python").debug_selection()
    end)
end

M.setup = function()
    setup_pylsp()
    setup_pyright()
    setup_ruff()
    setup_dap()
end


return M
