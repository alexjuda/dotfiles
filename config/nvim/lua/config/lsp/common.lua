local M = {}

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
    local buf_map_with_name = function(mode, lhs, rhs, name)
        local opts = { buffer = buf_n, noremap = true, desc = name }
        vim.keymap.set(mode, lhs, rhs, opts)
    end

    local telescope = require("telescope.builtin")

    -- See also: https://gpanders.com/blog/whats-new-in-neovim-0-11/#defaults
    -- It's mapped in insert and select mode already.
    buf_map_with_name("n", "<c-S>", function() vim.lsp.buf.signature_help() end, "signature help")

    -- Mapped to <c-]> by default.
    buf_map_with_name("n", "gd", function() telescope.lsp_definitions() end, "definition")
    buf_map_with_name("n", "gp", "<C-w>}", "preview definition")

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
end

-- Sensible defaults for all my LSP configs.
M.shared_on_attach = function(client, buf_n)
    set_lsp_keymaps(client, buf_n)
end

-- Sensible defaults for all my LSP configs.
M.shared_make_client_capabilities = function()
    -- For more about setting client capabilities with blink, see:
    -- https://cmp.saghen.dev/installation.html#merging-lsp-capabilities
    return require("blink.cmp.sources.lib").get_lsp_capabilities()
end

-- Infers the full executable path based on shell command name.
M.read_exec_path = function(exec_name)
    local handle = io.popen("which " .. exec_name)
    local result = handle:read("*a"):gsub("\n", "")
    handle:close()
    return result
end

-- Allows running LSP configuration only on file enter. LSP configuration takes time, even without connecting to the
-- actual server.
M.register_lsp_aucmd = function(group_name, filetypes, callback)
    local group = vim.api.nvim_create_augroup(group_name, { clear = true })

    vim.api.nvim_create_autocmd("FileType", {
        pattern = filetypes,
        group = group,
        callback = callback,
        desc = "Set up LSPs",
    })
end

return M
