local common = require("aj.lsp.common")

local M = {}


M.setup = function()
    -- Requires `typescript` and `typescript-language-server` packages.
    -- If they're not installed locally, it will fetch them each time.
    -- Anyway, installing:
    -- npm install -g typescript typescript-language-server

    require("lspconfig").ts_ls.setup {
        cmd = { "npx", "typescript-language-server", "--stdio", },
        on_attach = common.shared_on_attach,
        capabilities = common.make_shared_capabilities(),
    }
end


return M
