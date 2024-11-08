local M = {}


local setup_all_lang_servers = function()
    require("aj.lsp.cpp").setup()
    require("aj.lsp.helm").setup()
    require("aj.lsp.html").setup()
    require("aj.lsp.java").setup()
    require("aj.lsp.js").setup()
    require("aj.lsp.json").setup()
    require("aj.lsp.lua").setup()
    require("aj.lsp.markdown").setup()
    require("aj.lsp.python").setup()
    require("aj.lsp.rst").setup()
    require("aj.lsp.rust").setup()
    require("aj.lsp.yaml").setup()
end


M.setup = function()
    setup_all_lang_servers()
end


return M
