return {
    "nvim-treesitter/nvim-treesitter-context",
    lazy = true,
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
        -- The plugin is _enabled_ by default but not shown because we're only lazy loading it on toggle.
        enable = false,
        -- Defaults to "cursor" which is weird.
        mode = "topline",
    },
    cmd = { "TSContext" },
}
