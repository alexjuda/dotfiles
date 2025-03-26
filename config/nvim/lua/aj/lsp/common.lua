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

    -- TODO: remove maps made obsolete by v0.11.
    -- See also: https://gpanders.com/blog/whats-new-in-neovim-0-11/#defaults
    buf_map_with_name("n", "K", function() vim.lsp.buf.hover() end, "hover")
    buf_map_with_name("n", "grn", function() vim.lsp.buf.rename() end, "rename")
    buf_map_with_name("n", "grr", function() telescope.lsp_references() end, "references")
    buf_map_with_name("n", "gri", function() telescope.lsp_implementations() end, "implementations")
    buf_map_with_name("n", "gO", function() show_document_symbols() end, "document symbols")
    buf_map_with_name("n", "gra", function() vim.lsp.buf.code_action() end, "code action")
    buf_map_with_name({ "i", "s", "n" }, "<c-S>", function() vim.lsp.buf.signature_help() end, "signature help")

    buf_map_with_name("n", "gd", function() telescope.lsp_definitions() end, "definition")
    buf_map_with_name("n", "gD", function() telescope.lsp_type_definitions() end, "type definition")
    buf_map_with_name("n", "gci", function() telescope.lsp_incoming_calls() end, "incoming calls")
    buf_map_with_name("n", "gco", function() telescope.lsp_outgoing_calls() end, "outgoing calls")

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
        "n", "go",
        function() show_workspace_symbols() end,
        "workspace symbols"
    )

    wk.add({ "<localleader>l", desc = "+lsp commands" })
    wk.add({ "<localleader>lb", desc = "+buffer" })
    wk.add({ "<localleader>lw", desc = "+workspace" })
    wk.add({ "<localleader>L", desc = "+lsp connectors" })
end


M.shared_on_attach = function(client, buf_n)
    set_lsp_keymaps(client, buf_n)
end



M.make_shared_capabilities = function()
    return require('cmp_nvim_lsp').default_capabilities()
end


return M
