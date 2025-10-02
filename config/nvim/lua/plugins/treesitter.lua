return {
    "nvim-treesitter/nvim-treesitter",
    -- treesitter doesn't support lazy-loading.
    lazy = false,
    branch = "main",
    build = ":TSUpdate",
    config = function(opts)
        local ts = require("nvim-treesitter")
        ts.setup(opts)

        ts.install {
            "markdown",
        }

        vim.api.nvim_create_autocmd("FileType", {
            pattern = {
                "markdown"
            },
            callback = function() vim.treesitter.start() end,
        })
    end
}
