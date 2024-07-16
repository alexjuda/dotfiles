---------
-- LSP --
---------

-- show all lsp log msgs
-- vim.lsp.set_log_level("debug")

-- Makes the symbol preview more tidy. Python LSP server shows each local
-- variable in the symbol list. That's a lot of noise.
local show_document_symbols = function()
    require("telescope.builtin").lsp_document_symbols {
        ignore_symbols = { "variable" },
    }
end

local show_workspace_symbols = function()
    require("telescope.builtin").lsp_dynamic_workspace_symbols {
        ignore_symbols = { "variable" },
    }
end


-- Buffer-local options + keymap
local set_lsp_keymaps = function(client, buf_n)
    local wk = require("which-key")

    local buf_map_with_name = function(mode, lhs, rhs, name)
        local opts = { buffer = buf_n, noremap = true }
        vim.keymap.set(mode, lhs, rhs, opts)

        wk.register({ [lhs] = name })
    end

    local telescope = require("telescope.builtin")

    buf_map_with_name("n", "K", function() vim.lsp.buf.hover() end, "hover")
    buf_map_with_name("n", "<c-k>", function() vim.lsp.buf.signature_help() end, "signature help")

    buf_map_with_name("n", "gd", function() telescope.lsp_definitions() end, "definition")
    buf_map_with_name("n", "gD", function() vim.lsp.buf.declaration() end, "declaration")
    buf_map_with_name("n", "gi", function() telescope.lsp_implementations() end, "implementation")
    buf_map_with_name("n", "gr", function() telescope.lsp_references() end, "references")
    buf_map_with_name("n", "gt", function() telescope.lsp_type_definitions() end, "type definition")

    buf_map_with_name("n", "<localleader>lr", function() vim.lsp.buf.rename() end, "rename")
    buf_map_with_name("n", "<localleader>la", function() vim.lsp.buf.code_action() end, "code action")
    buf_map_with_name("n", "<localleader>lf", function() vim.lsp.buf.format() end, "format")
    buf_map_with_name("v", "<localleader>lf", function() vim.lsp.buf.format() end, "format")

    buf_map_with_name("n", "<localleader>lbs", function() show_document_symbols() end, "symbols in this buffer")
    buf_map_with_name(
        "n", "<localleader>lbd",
        function() telescope.diagnostics { bufnr = 0 } end,
        "diagnostics in this buffer"
    )

    buf_map_with_name(
        "n", "<localleader>lwd",
        function() telescope.diagnostics() end,
        "diagnostics in workspace"
    )
    buf_map_with_name(
        "n", "<localleader>lws",
        function() show_workspace_symbols() end,
        "symbols in workspace"
    )

    wk.register({ ["<localleader>l"] = "+lsp commands" })
    wk.register({ ["<localleader>lb"] = "+buffer" })
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

-- Infers the full executable path based on shell command name
local read_exec_path = function(exec_name)
    local handle = io.popen("which " .. exec_name)
    local result = handle:read("*a"):gsub("\n", "")
    handle:close()
    return result
end


-- Requires ``pyright`` installed via npm.
require("lspconfig").pyright.setup {
    settings = {
        python = {
            -- Use the locally available python executable. Enables using pyright from an activated venv.
            pythonPath = read_exec_path("python"),
        },
    },
    on_attach = function(client, buf_n)
        shared_on_attach(client, buf_n)
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
-- Requires `lua-language=server` available at PATH.
require("lspconfig").lua_ls.setup {
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = 'LuaJIT',
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

-- local function read_dict_words()
--     -- Workaround for ltex-ls not reading/writing dict files.

--     local path = vim.env.HOME .. "/.local/share/lang-servers/ltex-ls-data/dict.txt"

--     local f = io.open(path)
--     if f == nil then
--         print("Warning: dict file doesn't exist at" .. path)
--         return {}
--     end
--     io.close(f)

--     local lines = {}
--     for line in io.lines(path) do
--         lines[#lines + 1] = line
--     end

--     return lines
-- end

-- require("lspconfig").ltex.setup {
--     on_attach = shared_on_attach,
--     settings = {
--         ltex = {
--             dictionary = {
--                 ["en-US"] = read_dict_words(),
--             },
--         },
--     },
-- }


-- esbonio --
-------------
--
-- Language server for Sphinx and rst.

require("lspconfig").esbonio.setup {
    on_attach = shared_on_attach,
    cmd = { "esbonio", },
}


-- html --
----------
--
-- Language server for html, css, and js.
-- Requires installing https://github.com/hrsh7th/vscode-langservers-extracted

require("lspconfig").html.setup {
    on_attach = shared_on_attach,
    cmd = { "npx", "vscode-html-language-server", "--stdio", },
}


-- ccls --
-- C++ and other languages from the C family.
-- Installation on Fedora: https://stackoverflow.com/a/71810871
require("lspconfig").ccls.setup {
    on_attach = shared_on_attach,
    -- Add cuda to the default filetypes list.
    filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
}


-- Markdown --
----------------
-- Requires `marksman` installed. Get it from
-- https://github.com/artempyanykh/marksman/releases.

require("lspconfig").marksman.setup {
    on_attach = shared_on_attach,
    capabilities = shared_capabilities,
}
