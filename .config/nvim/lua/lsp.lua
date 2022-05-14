---------
-- LSP --
---------

-- show all lsp log msgs
-- vim.lsp.set_log_level("debug")

-- Buffer-local options + keymap

local set_lsp_keymaps = function(client, buf_n)
    -- We use completion-nvim autocompletion popup instead of the built-in omnifunc
    -- `<Plug>` commands need recursive mapping.

    -- Keymap
    local opts = { noremap=true }
    vim.api.nvim_buf_set_keymap(buf_n, "n", "K", ":lua vim.lsp.buf.hover()<CR>", opts)
    vim.api.nvim_buf_set_keymap(buf_n, "n", "<localleader>ld", ":lua vim.lsp.buf.definition()<CR>", opts)
    vim.api.nvim_buf_set_keymap(buf_n, "n", "<localleader>lD", ":lua vim.lsp.buf.references()<CR>", opts)
    vim.api.nvim_buf_set_keymap(buf_n, "n", "<localleader>li", ":LspInfo<CR>", opts)
    vim.api.nvim_buf_set_keymap(buf_n, "n", "<localleader>lr", ":lua vim.lsp.buf.rename()<CR>", opts)
    vim.api.nvim_buf_set_keymap(buf_n, "n", "<localleader>la", ":lua vim.lsp.buf.code_action()<CR>", opts)
    vim.api.nvim_buf_set_keymap(buf_n, "v", "<localleader>la", ":lua vim.lsp.buf.range_code_action()<CR>", opts)

    -- Set keymap only if language server supports it. This way which-key window will show only supported stuff.
    if client.resolved_capabilities.document_formatting then
        vim.api.nvim_buf_set_keymap(buf_n, "n", "<localleader>lf", ":lua vim.lsp.buf.formatting()<CR>", opts)
    end
    if client.resolved_capabilities.document_range_formatting then
        vim.api.nvim_buf_set_keymap(buf_n, "v", "<localleader>lf", ":lua vim.lsp.buf.range_formatting()<CR>", opts)
    end
end

local shared_on_attach = function(client, buf_n)
    -- Hook LSP with omnifunc completions.
    -- src: https://neovim.io/doc/user/lsp.html
    -- NOTE: this is the built-in completion fired by <C-x><C-o>. It's an alternative to
    -- the <C-Space> autocompletion powered by nvim-cmp.
    vim.api.nvim_buf_set_option(buf_n, "omnifunc", "v:lua.vim.lsp.omnifunc")

    set_lsp_keymaps(client, buf_n)
end


-- extend default client capabilities with what cmp can do

local shared_capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
-- require('lspconfig')[%YOUR_LSP_SERVER%].setup {
--     capabilities = shared_capabilities
-- }

-- Python --
------------

require("lspconfig").pylsp.setup {
    settings = {
        pylsp = {
            configurationSources = {"flake8"},
        },
    },
    on_attach = function(client, buf_n)
        shared_on_attach(client, buf_n)

        -- python-specific keybindings
        vim.api.nvim_buf_set_keymap(buf_n, "n", "<localleader>se", "<Plug>JupyterExecute", {})
        vim.api.nvim_buf_set_keymap(buf_n, "n", "<localleader>sa", "<Plug>JupyterExecuteAll", {})
    end,
    capabilities = shared_capabilities,
}


-- JavaScript --
----------------
-- Requires `typescript` and `typescript-language-server` packages.
-- If they're not installed locally, it will fetch them each time.

require("lspconfig").tsserver.setup {
    cmd = { "npx", "typescript-language-server", "--stdio", },
    on_attach = shared_on_attach,
    capabilities = shared_capabilities,
}

-- JSON --
----------------
-- Requires `vscode-langservers-extracted` package.

require("lspconfig").jsonls.setup {
    commands = {
        -- add support for full buffer formatting using range formatting
        Format = {
            function()
                vim.lsp.buf.range_formatting({},{0,0},{vim.fn.line("$"),0})
            end
        },
    },
    on_attach = shared_on_attach,
    capabilities = shared_capabilities,
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
    capabilities = shared_capabilities,
}

-- Lua --
---------
-- Assumes that a language server repo with a built LS binary is available under
-- ~/.local/share/aj-lsp/ . To get it, follow the instructions from:
-- https://jdhao.github.io/2021/08/12/nvim_sumneko_lua_conf/#build .
--
-- The configuration is based on snippet at
-- https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#sumneko_lua

local sumneko_cmd = function()
    return {
        vim.env.HOME
        .. "/.local/share/aj-lsp/lua-language-server/bin/lua-language-server"
    }
end


local lua_runtime_paths = function()
    local runtime_path = vim.split(package.path, ';')
    table.insert(runtime_path, "lua/?.lua")
    table.insert(runtime_path, "lua/?/init.lua")

    return runtime_path
end

require("lspconfig").sumneko_lua.setup {
    cmd = sumneko_cmd(),
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = 'LuaJIT',
                -- Setup your lua path
                path = lua_runtime_paths(),
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = {'vim'},
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true),
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
                enable = false,
            },
        },
    },
    on_attach = shared_on_attach,
    capabilities = shared_capabilities,
}


-- Rust --
----------
-- Requires `rust-analyzer` installed.

require("lspconfig").rust_analyzer.setup {
    on_attach = shared_on_attach,
    capabilities = shared_capabilities,
}
