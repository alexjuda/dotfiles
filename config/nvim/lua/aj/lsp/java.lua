local common = require("aj.lsp.common")

local M = {}


local is_mac = function()
    return vim.fn.has("macunix") == 1
end

M.setup = function()
    ----------
    -- Assumes that a language server distribution is available in the proper
    -- directory. Fetch it from https://ftp.fau.de/eclipse/jdtls/snapshots/, put it
    -- in ~/.local/share/aj-lsp/ and make a symlink so the paths here work.

    require("lspconfig").jdtls.setup {
        cmd = {
            "java",
            "-jar",
            vim.env.HOME .. "/.local/share/aj-lsp/jdtls/plugins/org.eclipse.equinox.launcher_1.6.100.v20201223-0822.jar",
            "-configuration",
            vim.env.HOME .. "/.local/share/aj-lsp/jdtls/" .. (is_mac() and "config_mac" or "config_linux"),
        },
        on_attach = common.shared_on_attach,
        capabilities = common.shared_capabilities,
    }
end


return M
