return {
    "NickvanDyke/opencode.nvim",
    lazy = true,
    dependencies = {
        -- Shows nicely rendered TUIs for option selection.
        { "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } },
    },
    config = function()
        ---@type opencode.Opts
        vim.g.opencode_opts = {
            provider = {
                enabled = "wezterm",
            }
        }
    end,
}
