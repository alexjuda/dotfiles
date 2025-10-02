return {
    "nvim-treesitter/nvim-treesitter",
    -- treesitter doesn't support lazy-loading.
    lazy = false,
    branch = "main",
    build = ":TSUpdate",
    opts = {
        -- ensure_installed = {
        --     "markdown",
        -- },
    },
    config = function(opts)
        local ts = require("nvim-treesitter")
        ts.setup(opts)
        ts.install {
            "markdown",
        }
    end
}
