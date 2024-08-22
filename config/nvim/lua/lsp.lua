local common = require("lsp2.common")
local lsp_python = require("lsp2.python")
local lsp_js = require("lsp2.js")
local lsp_json = require("lsp2.json")
local lsp_java = require("lsp2.java")

---------
-- LSP --
---------

-- show all lsp log msgs
-- vim.lsp.set_log_level("debug")

lsp_python.setup()
lsp_js.setup()
lsp_json.setup()
lsp_java.setup()

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
    on_attach = common.shared_on_attach,
    capabilities = common.shared_capabilities,
}


-- Rust --
----------
-- Requires `rust-analyzer` available at PATH. Installation:
-- https://rust-analyzer.github.io/manual.html#rust-analyzer-language-server-binary
--
-- For LSP settings, see also:
-- https://rust-analyzer.github.io/manual.html#nvim-lsp

require("lspconfig").rust_analyzer.setup {
    on_attach = common.shared_on_attach,
    capabilities = common.shared_capabilities,
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
--     on_attach = common.shared_on_attach,
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
    on_attach = common.shared_on_attach,
    cmd = { "esbonio", },
}


-- html --
----------
--
-- Language server for html, css, and js.
-- Requires installing https://github.com/hrsh7th/vscode-langservers-extracted

require("lspconfig").html.setup {
    on_attach = common.shared_on_attach,
    cmd = { "npx", "vscode-html-language-server", "--stdio", },
}


-- ccls --
-- C++ and other languages from the C family.
-- Installation on Fedora: https://stackoverflow.com/a/71810871
require("lspconfig").ccls.setup {
    on_attach = common.shared_on_attach,
    -- Add cuda to the default filetypes list.
    filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
}


-- Markdown --
----------------
-- Requires `marksman` installed. Get it from
-- https://github.com/artempyanykh/marksman/releases.

require("lspconfig").marksman.setup {
    on_attach = common.shared_on_attach,
    capabilities = common.shared_capabilities,
}
