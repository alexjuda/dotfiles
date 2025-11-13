local M = {}

M.setup = function()
    require("config.lsp.cpp").setup()
    require("config.lsp.html").setup()
    require("config.lsp.helm").setup()
    require("config.lsp.java").setup()
    require("config.lsp.js").setup()
    require("config.lsp.json").setup()
    require("config.lsp.markdown").setup()
    require("config.lsp.lua").setup()
    require("config.lsp.python").setup()
    require("config.lsp.tf").setup()
end

return M
