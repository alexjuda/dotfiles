-- Utilities shared across language server configurations.

M = {}

-- Makes the symbol preview more tidy. Python LSP server shows each local
-- variable in the symbol list. That's a lot of noise.
local show_document_symbols = function()
    require("telescope.builtin").lsp_document_symbols {
        ignore_symbols = { "variable" },
    }
end

local show_workspace_symbols = function()
    require("telescope.builtin").lsp_dynamic_workspace_symbols {
        ignore_symbols = { "variable" },
    }
end

-- Buffer-local options + keymap
local set_lsp_keymaps = function(client, buf_n)
    local wk = require("which-key")

    local buf_map_with_name = function(mode, lhs, rhs, name)
        local opts = { buffer = buf_n, noremap = true }
        vim.keymap.set(mode, lhs, rhs, opts)

        wk.add({ lhs, desc = name })
    end

    local telescope = require("telescope.builtin")

    buf_map_with_name("n", "K", function() vim.lsp.buf.hover() end, "hover")
    buf_map_with_name("n", "<c-k>", function() vim.lsp.buf.signature_help() end, "signature help")

    buf_map_with_name("n", "gd", function() telescope.lsp_definitions() end, "definition")
    buf_map_with_name("n", "gD", function() vim.lsp.buf.declaration() end, "declaration")
    buf_map_with_name("n", "gi", function() telescope.lsp_implementations() end, "implementation")
    buf_map_with_name("n", "gr", function() telescope.lsp_references() end, "references")
    buf_map_with_name("n", "gt", function() telescope.lsp_type_definitions() end, "type definition")

    buf_map_with_name("n", "<localleader>lr", function() vim.lsp.buf.rename() end, "rename")
    buf_map_with_name("n", "<localleader>la", function() vim.lsp.buf.code_action() end, "code action")
    buf_map_with_name("n", "<localleader>lf", function() vim.lsp.buf.format() end, "format")
    buf_map_with_name("v", "<localleader>lf", function() vim.lsp.buf.format() end, "format")

    buf_map_with_name("n", "<localleader>lbs", function() show_document_symbols() end, "symbols in this buffer")
    buf_map_with_name(
        "n", "<localleader>lbd",
        function() telescope.diagnostics { bufnr = 0 } end,
        "diagnostics in this buffer"
    )

    buf_map_with_name(
        "n", "<localleader>lwd",
        function() telescope.diagnostics() end,
        "diagnostics in workspace"
    )
    buf_map_with_name(
        "n", "<localleader>lws",
        function() show_workspace_symbols() end,
        "symbols in workspace"
    )

    wk.add({ "<localleader>l", desc = "+lsp commands" })
    wk.add({ "<localleader>lb", desc = "+buffer" })
    wk.add({ "<localleader>lw", desc = "+workspace" })
    wk.add({ "<localleader>L", desc = "+lsp connectors" })
end


M.shared_on_attach = function(client, buf_n)
    set_lsp_keymaps(client, buf_n)
end


-- extend default client capabilities with what cmp can do
M.shared_capabilities = require('cmp_nvim_lsp').default_capabilities()

M.make_shared_capabilities = function()
    return require('cmp_nvim_lsp').default_capabilities()
end


return M
