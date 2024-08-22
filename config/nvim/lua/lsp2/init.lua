local M = {}


M.setup_all_lang_servers = function()
    require("lsp2.cpp").setup()
    require("lsp2.html").setup()
    require("lsp2.java").setup()
    require("lsp2.js").setup()
    require("lsp2.json").setup()
    require("lsp2.lua").setup()
    require("lsp2.markdown").setup()
    require("lsp2.python").setup()
    require("lsp2.rst").setup()
    require("lsp2.rust").setup()
end


return M
