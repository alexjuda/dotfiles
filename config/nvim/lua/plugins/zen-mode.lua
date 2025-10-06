return {
    "folke/zen-mode.nvim",
    lazy = true,
    opts = {
        window = {
            backdrop = 1.0,
            width = 80,
            options = {
                signcolumn = "no",
                number = false,
                cursorline = false,
                foldcolumn = "0",
            },
        },
    },
    cmd = { "ZenMode" },
}
