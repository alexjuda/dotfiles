local common = require("lsp2.common")

local M = {}


M.setup = function()
    -- Requires `typescript` and `typescript-language-server` packages.
    -- If they're not installed locally, it will fetch them each time.

    require("lspconfig").tsserver.setup {
        cmd = { "npx", "typescript-language-server", "--stdio", },
        on_attach = common.shared_on_attach,
        capabilities = common.shared_capabilities,
    }
end


return M
