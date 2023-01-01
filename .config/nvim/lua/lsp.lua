---------
-- LSP --
---------

-- show all lsp log msgs
-- vim.lsp.set_log_level("debug")

-- Buffer-local options + keymap

local wk = require("which-key")
local aerial = require("aerial")

local set_lsp_keymaps = function(client, buf_n)
    -- Keymap
    local opts = { noremap = true }
    vim.api.nvim_buf_set_keymap(buf_n, "n", "K", ":lua vim.lsp.buf.hover()<CR>", opts)
    vim.api.nvim_buf_set_keymap(buf_n, "n", "gd", ":lua vim.lsp.buf.definition()<CR>", opts)
    vim.api.nvim_buf_set_keymap(buf_n, "n", "gr", ":lua vim.lsp.buf.references()<CR>", opts)
    vim.api.nvim_buf_set_keymap(buf_n, "n", "gt", ":lua vim.lsp.buf.type_definition()<CR>", opts)
    vim.api.nvim_buf_set_keymap(buf_n, "n", "<localleader>lr", ":lua vim.lsp.buf.rename()<CR>", opts)
    vim.api.nvim_buf_set_keymap(buf_n, "n", "<localleader>la", ":lua vim.lsp.buf.code_action()<CR>", opts)
    vim.api.nvim_buf_set_keymap(buf_n, "n", "<localleader>ld", ":lua vim.lsp.buf.document_symbol()<CR>", opts)
    vim.api.nvim_buf_set_keymap(buf_n, "n", "<localleader>lf", ":lua vim.lsp.buf.format()<CR>", opts)
    vim.api.nvim_buf_set_keymap(buf_n, "v", "<localleader>lf", ":lua vim.lsp.buf.range_formatting()<CR>", opts)
    vim.api.nvim_buf_set_keymap(buf_n, "n", "<localleader>ls", ":lua vim.lsp.buf.signature_help()<CR>", opts)

    vim.api.nvim_buf_set_keymap(buf_n, "n", "<localleader>lws", ":lua vim.lsp.buf.workspace_symbol()<CR>", opts)
    vim.api.nvim_buf_set_keymap(buf_n, "n", "<localleader>lwf", ":lua vim.lsp.buf.list_workspace_folders()<CR>", opts)

    wk.register({ ["<localleader>l"] = "+lsp commands" })
    wk.register({ ["<localleader>lw"] = "+workspace" })
    wk.register({ ["<localleader>L"] = "+lsp connectors" })
end

local shared_on_attach = function(client, buf_n)
    set_lsp_keymaps(client, buf_n)
end


-- extend default client capabilities with what cmp can do
local shared_capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Python --
------------

-- Requires ``pyright`` installed via npm.
require("lspconfig").pyright.setup {
    cmd = { "npx", "pyright-langserver", "--stdio", },
    settings = {
    },
    on_attach = function(client, buf_n)
        shared_on_attach(client, buf_n)

        -- python-specific keybindings
        vim.api.nvim_buf_set_keymap(buf_n, "n", "<localleader>se", "<Plug>JupyterExecute", {})
        vim.api.nvim_buf_set_keymap(buf_n, "n", "<localleader>sa", "<Plug>JupyterExecuteAll", {})

    end,
    capabilities = shared_capabilities,
}

-- Requires `python-lsp-server` pip package.
require("lspconfig").pylsp.setup {
    settings = {
        pylsp = {
            configurationSources = { "flake8" },
        },
    },
    on_attach = function(client, buf_n)
        shared_on_attach(client, buf_n)

        -- Disable capabilities already covered by pyright.
        -- Based on https://neovim.discourse.group/t/how-to-config-multiple-lsp-for-document-hover/3093/2
        --
        -- Seems to work around buggy autocomplete behavior, where the symbol disappears after hitting <CR>.
        client.server_capabilities.hoverProvider = false
        client.server_capabilities.completionProvider = nil
        -- Workaround for duplicated "new symbol name" prompts.
        client.server_capabilities.renameProvider = false
    end,
    capabilities = shared_capabilities,
}


-- JavaScript --
----------------
-- Requires `typescript` and `typescript-language-server` packages.
-- If they're not installed locally, it will fetch them each time.

require("lspconfig").tsserver.setup {
    cmd = { "npx", "typescript-language-server", "--stdio", },
    on_attach = shared_on_attach,
    capabilities = shared_capabilities,
}

-- JSON --
----------------
-- Requires `vscode-langservers-extracted` package.

require("lspconfig").jsonls.setup {
    commands = {
        -- add support for full buffer formatting using range formatting
        Format = {
            function()
                vim.lsp.buf.range_formatting({}, { 0, 0 }, { vim.fn.line("$"), 0 })
            end
        },
    },
    on_attach = shared_on_attach,
    capabilities = shared_capabilities,
}

-- Java --
----------
-- Assumes that a language server distribution is available in the proper
-- directory. Fetch it from https://ftp.fau.de/eclipse/jdtls/snapshots/, put it
-- in ~/.local/share/aj-lsp/ and make a symlink so the paths here work.

local is_mac = function()
    return vim.fn.has("macunix") == 1
end

require("lspconfig").jdtls.setup {
    cmd = {
        "java",
        "-jar",
        vim.env.HOME .. "/.local/share/aj-lsp/jdtls/plugins/org.eclipse.equinox.launcher_1.6.100.v20201223-0822.jar",
        "-configuration",
        vim.env.HOME .. "/.local/share/aj-lsp/jdtls/" .. (is_mac() and "config_mac" or "config_linux"),
    },
    on_attach = shared_on_attach,
    capabilities = shared_capabilities,
}

-- Lua --
---------
-- Assumes that a language server repo with a built LS binary is available under
-- ~/.local/share/aj-lsp/ . To get it, follow the instructions from:
-- https://jdhao.github.io/2021/08/12/nvim_sumneko_lua_conf/#build .
--
-- The configuration is based on snippet at
-- https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#sumneko_lua

local sumneko_cmd = function()
    return { "lua-language-server" }
end


local lua_runtime_paths = function()
    local runtime_path = vim.split(package.path, ';')
    table.insert(runtime_path, "lua/?.lua")
    table.insert(runtime_path, "lua/?/init.lua")

    return runtime_path
end

require("lspconfig").sumneko_lua.setup {
    cmd = sumneko_cmd(),
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = 'LuaJIT',
                -- Setup your lua path
                path = lua_runtime_paths(),
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = { 'vim' },
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true),
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
                enable = false,
            },
        },
    },
    on_attach = shared_on_attach,
    capabilities = shared_capabilities,
}


-- Rust --
----------
-- Requires `rust-analyzer` available at PATH. Installation:
-- https://rust-analyzer.github.io/manual.html#rust-analyzer-language-server-binary
--
-- For LSP settings, see also:
-- https://rust-analyzer.github.io/manual.html#nvim-lsp

require("lspconfig").rust_analyzer.setup {
    on_attach = shared_on_attach,
    capabilities = shared_capabilities,
}


-- ltex-ls --
-------------
-- LaTeX & Markdown linter based on LanguageTool.
--
-- Assumes that `ltex-ls` is installed and is available in the $PATH.
-- Install from a release from: https://github.com/valentjn/ltex-ls/releases.

local function read_dict_words()
    -- Workaround for ltex-ls not reading/writing dict files.

    local path = vim.env.HOME .. "/.local/share/lang-servers/ltex-ls-data/dict.txt"

    local f = io.open(path)
    if f == nil then
        print("Warning: dict file doesn't exist at" .. path)
        return {}
    end
    io.close(f)

    local lines = {}
    for line in io.lines(path) do
        lines[#lines + 1] = line
    end

    return lines
end

require("lspconfig").ltex.setup {
    on_attach = shared_on_attach,
    settings = {
        ltex = {
            dictionary = {
                ["en-US"] = read_dict_words(),
            },
        },
    },
    filetypes = { "markdown", "tex", },
}


-- esbonio --
-------------
--
-- Language server for Sphinx and rst.

require("lspconfig").esbonio.setup {
    on_attach = shared_on_attach,
    cmd = { "esbonio", },
}
