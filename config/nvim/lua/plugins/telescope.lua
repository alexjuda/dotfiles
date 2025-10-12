return {
    "nvim-telescope/telescope.nvim",
    lazy = true,
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
        defaults = {
            layout_strategy = "vertical",
            layout_config = {
                vertical = {
                    height = 0.99,
                    width = 0.99,
                },
            },
        },
    },
}
