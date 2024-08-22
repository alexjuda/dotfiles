local common = require("lsp.common")

local M = {}


M.setup = function()
    -- Requires `rust-analyzer` available at PATH. Installation:
    -- https://rust-analyzer.github.io/manual.html#rust-analyzer-language-server-binary
    --
    -- For LSP settings, see also:
    -- https://rust-analyzer.github.io/manual.html#nvim-lsp

    require("lspconfig").rust_analyzer.setup {
        on_attach = common.shared_on_attach,
        capabilities = common.shared_capabilities,
    }
end


return M
