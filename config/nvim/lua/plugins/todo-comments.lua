return {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    lazy = false,
    opts = {
        highlight = {
            pattern = {
                -- example: 'TODO: abc'
                [[.*<(KEYWORDS)\s*:]],
                -- example: 'TODO (JIRA-123): abc'
                [[.*<((KEYWORDS)\s*\(.*\)*)\s*:]],
            },
        },
    }
}
