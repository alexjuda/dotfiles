return {
    {
        "catppuccin/nvim",
        name = "catppuccin",
        -- This is my main colorscheme. Need to always load it.
        lazy = false,
        config = function()
            vim.cmd.colorscheme "catppuccin"
        end
    },
    {
        "rose-pine/nvim",
        lazy = true,
        name = "rose-pine",
    },
}
