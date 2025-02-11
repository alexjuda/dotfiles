local common = require("aj.lsp.common")

local M = {}


M.setup = function()
    -- Requires `yaml-language-server` package.
    -- If they're not installed locally, it will fetch them each time.
    -- Anyway, installing:
    -- npm install -g yaml-language-server

    -- require("lspconfig").yamlls.setup {
    --     cmd = { "npx", "yaml-language-server", "--stdio", },
    --     on_attach = common.shared_on_attach,
    --     capabilities = common.make_shared_capabilities(),
    -- }
end


return M
