return {
    'nvim-mini/mini-git',
    version = false,
    lazy = true,
    -- lazy.nvim's heuristic for finding root module fails for '-git' suffix.
    main = "mini.git",
    opts = {},
}
