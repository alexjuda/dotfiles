return {
    "dmtrKovalenko/fff.nvim",
    build = function()
        require("fff.download").download_or_build_binary()
    end,
    opts = {
        debug = {
            enabled = true,
            show_scores = true,
        },
    },
    -- No need to lazy-load with lazy.nvim. This plugin initializes itself lazily.
    lazy = false,
}
