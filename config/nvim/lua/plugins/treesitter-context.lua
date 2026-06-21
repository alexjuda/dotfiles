return {
    "nvim-treesitter/nvim-treesitter-context",
    lazy = false,
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
        -- The plugin is _enabled_ by default but not shown because we're only lazy loading it on toggle.
        enable = true,
        -- Defaults to "cursor" which is weird.
        mode = "topline",
    },
    cmd = { "TSContext" },
}
