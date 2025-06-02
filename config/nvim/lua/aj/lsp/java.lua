local common = require("aj.lsp.common")

local M = {}


local is_mac = function()
    return vim.fn.has("macunix") == 1
end

local script_name = function()
    if is_mac() then
        return "lang_server_mac.sh"
    else
        return "lang_server_linux.sh"
    end
end

M.setup = function()
    -- See https://github.com/georgewfraser/java-language-server for build instructions.
    -- Then, copy 'dist' under '~/.local/share/aj-apps/java-language-server/'.
    require("lspconfig").jdtls.setup {
        cmd = {
            vim.env.HOME
            .. "/.local/share/aj-apps/java-language-server/dist/"
            .. script_name()
        },
        on_attach = common.shared_on_attach,
        capabilities = common.make_shared_capabilities(),
    }
end


return M
