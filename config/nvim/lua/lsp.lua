local M = {}


local setup_all_lang_servers = function()
    require("lsp.cpp").setup()
    require("lsp.html").setup()
    require("lsp.java").setup()
    require("lsp.js").setup()
    require("lsp.json").setup()
    require("lsp.lua").setup()
    require("lsp.markdown").setup()
    require("lsp.python").setup()
    require("lsp.rst").setup()
    require("lsp.rust").setup()
end


M.setup = function()
    setup_all_lang_servers()
end


return M
