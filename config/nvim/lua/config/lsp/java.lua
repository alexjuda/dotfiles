local M = {}


local script_name = function()
    if require("config.switchers").on_mac() then
        return "lang_server_mac.sh"
    else
        return "lang_server_linux.sh"
    end
end

local filetypes = { "java" }

-- See https://github.com/georgewfraser/java-language-server for build instructions. Then, copy 'dist' under
-- '~/.local/share/aj-apps/java-language-server/'.
local function setup_jdtls()
    local common = require("config.lsp.common")
    vim.lsp.config("jdtls", {
        cmd = {
            vim.env.HOME
            .. "/.local/share/aj-apps/java-language-server/dist/"
            .. script_name()
        },
        filetypes = filetypes,
        on_attach = common.shared_on_attach,
        capabilities = common.shared_make_client_capabilities(),
    })

    vim.lsp.enable("jdtls")
end


M.setup = function()
    local common = require("config.lsp.common")
    common.register_lsp_aucmd("JavaLSPSetup", filetypes, function()
        setup_jdtls()
    end)
end


return M
