---------
-- LSP --
---------

-- show all lsp log msgs
-- vim.lsp.set_log_level("debug")

-- Buffer-local options + keymap

local set_lsp_keymaps = function(client, buf_n)
    -- We use competion-nvim autocompletion popup instead of the built-in omnifunc
    -- `<Plug>` commands need recursive mapping.
    vim.api.nvim_buf_set_keymap(buf_n, "i", "<C-Space>", "<Plug>(completion_trigger)", { noremap=false })

    -- Keymap
    local opts = { noremap=true }
    vim.api.nvim_buf_set_keymap(buf_n, "n", "K", ":lua vim.lsp.buf.hover()<CR>", opts)
    vim.api.nvim_buf_set_keymap(buf_n, "n", "<localleader>ld", ":lua vim.lsp.buf.definition()<CR>", opts)
    vim.api.nvim_buf_set_keymap(buf_n, "n", "<localleader>lD", ":lua vim.lsp.buf.references()<CR>", opts)
    vim.api.nvim_buf_set_keymap(buf_n, "n", "<localleader>li", ":LspInfo<CR>", opts)
    vim.api.nvim_buf_set_keymap(buf_n, "n", "<localleader>lr", ":lua vim.lsp.buf.rename()<CR>", opts)
    vim.api.nvim_buf_set_keymap(buf_n, "n", "<localleader>la", ":lua vim.lsp.buf.code_action()<CR>", opts)

    -- Set keymap only if language server supports it. This way which-key window will show only supported stuff.
    if client.resolved_capabilities.document_formatting then
        vim.api.nvim_buf_set_keymap(buf_n, "n", "<localleader>lf", ":lua vim.lsp.buf.formatting()<CR>", opts)
    end
    if client.resolved_capabilities.document_range_formatting then
        vim.api.nvim_buf_set_keymap(buf_n, "v", "<localleader>lf", ":lua vim.lsp.buf.range_formatting()<CR>", opts)
    end
end

local shared_on_attach = function(client, buf_n)
    -- Set up completion-nvim
    require("completion").on_attach(client, buf_n)

    -- TODO: port recommended completion options from
    -- https://github.com/alexjuda/dotfiles/blob/7bb4b1803b9d8ce52c77256cc8477cc6ed45e8f5/.config/nvim/init.vim#L168

    set_lsp_keymaps(client, buf_n)
end

-- Python --
------------

require("lspconfig").pyls.setup {
    settings = {
        pyls = {
            configurationSources = {"flake8"},
        },
    },
    on_attach = shared_on_attach,
}


-- Java --
----------
-- Assumes that a language server distribution is available in the proper
-- directory. Fetch it from https://ftp.fau.de/eclipse/jdtls/snapshots/, put it
-- in ~/.local/share/aj-lsp/ and make a symlink so the paths here work.

local is_mac = function() 
    return vim.fn.has("macunix") == 1
end

require("lspconfig").jdtls.setup {
    cmd = {
        "java",
        "-jar",
        vim.env.HOME .. "/.local/share/aj-lsp/jdtls/plugins/org.eclipse.equinox.launcher_1.6.100.v20201223-0822.jar",
        "-configuration",
        vim.env.HOME .. "/.local/share/aj-lsp/jdtls/" .. (is_mac() and "config_mac" or "config_linux"),
    },

    on_attach = shared_on_attach,
}


