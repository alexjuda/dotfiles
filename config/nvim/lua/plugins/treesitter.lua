return {
    "nvim-treesitter/nvim-treesitter",
    -- treesitter doesn't support lazy-loading.
    lazy = false,
    branch = "main",
    build = ":TSUpdate"
}
