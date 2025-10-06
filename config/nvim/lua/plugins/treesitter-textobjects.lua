return {
    "nvim-treesitter/nvim-treesitter-textobjects",
    lazy = true,
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    branch = "main",
    opts = {
        select = {
            -- Automatically jump forward to textobj, similar to targets.vim
            -- lookahead = true,

            selection_modes = {
                ['@parameter.outer'] = 'v', -- charwise
                ['@function.outer'] = 'V', -- linewise
                ['@class.outer'] = 'V', -- linewise
            },
        },
    }
}
