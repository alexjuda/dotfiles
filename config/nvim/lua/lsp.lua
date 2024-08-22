local common = require("lsp2.common")
local lsp_python = require("lsp2.python")
local lsp_js = require("lsp2.js")
local lsp_json = require("lsp2.json")
local lsp_java = require("lsp2.java")
local lsp_lua = require("lsp2.lua")
local lsp_html = require("lsp2.html")
local lsp_rst = require("lsp2.rst")
local lsp_rust = require("lsp2.rust")
local lsp_markdown = require("lsp2.markdown")
local lsp_cpp = require("lsp2.cpp")

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
lsp_html.setup()
lsp_rst.setup()
lsp_rust.setup()
lsp_markdown.setup()
lsp_cpp.setup()
