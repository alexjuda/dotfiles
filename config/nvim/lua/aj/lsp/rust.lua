local common = require("aj.lsp.common")

local M = {}


M.setup = function()
    -- Requires `rust-analyzer` available at PATH. Installation:
    -- https://rust-analyzer.github.io/manual.html#rust-analyzer-language-server-binary
    --
    -- For LSP settings, see also:
    -- https://rust-analyzer.github.io/manual.html#nvim-lsp

    vim.lsp.config("rust_analyzer", {
        on_attach = common.shared_on_attach,
        capabilities = common.make_shared_capabilities(),
    })

    vim.lsp.enable("rust_analyzer")
end


return M
