return {
    "gruvw/strudel.nvim",
    lazy = true,
    build = "npm ci",
    config = function ()
        require("strudel").setup()
    end
}
