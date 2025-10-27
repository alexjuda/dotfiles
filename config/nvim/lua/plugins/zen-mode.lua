return {
    "folke/zen-mode.nvim",
    lazy = true,
    opts = {
        window = {
            -- Don't make the side margins of a different shade color than the make text.
            backdrop = 1.0,
            -- Defaults to something like 120. I use 100 line lengths for markdown.
            width = 100,
            options = {
                -- Clear the columns on the left.
                signcolumn = "no",
                number = false,
                foldcolumn = "0",
            },
        },
    },
    cmd = { "ZenMode" },
}
