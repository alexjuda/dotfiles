return {
    "linrongbin16/lsp-progress.nvim",
    lazy = true,
    opts = {
        -- Override format so it doesn't say "[] LSP". We have another mini-statusline segment for it.
        -- Original impl at https://github.com/linrongbin16/lsp-progress.nvim/blob/main/lua/lsp-progress/defaults.lua
        format = function(client_messages)
        return table.concat(client_messages, " ")
    end,
    },
}
