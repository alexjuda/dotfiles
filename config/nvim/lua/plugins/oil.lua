return {
    "stevearc/oil.nvim",
    opts = {
        view_options = {
            show_hidden = true,
            -- Defaults to sorting by type first.
            sort = {
                { "name", "asc" },
                { "type", "asc" },
            },
        },
    },
    dependencies = { { "nvim-mini/mini.icons", opts = {} } },
    -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
    lazy = false,
}
