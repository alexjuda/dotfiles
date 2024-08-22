local common = require("lsp2.common")
local lsp_python = require("lsp2.python")
local lsp_js = require("lsp2.js")
local lsp_json = require("lsp2.json")
local lsp_java = require("lsp2.java")
local lsp_lua = require("lsp2.lua")
local lsp_rst = require("lsp2.rst")
local lsp_rust = require("lsp2.rust")
local lsp_markdown = require("lsp2.markdown")

---------
-- LSP --
---------

-- show all lsp log msgs
-- vim.lsp.set_log_level("debug")

lsp_python.setup()
lsp_js.setup()
lsp_json.setup()
lsp_java.setup()
lsp_lua.setup()
lsp_rst.setup()
lsp_rust.setup()
lsp_markdown.setup()


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
