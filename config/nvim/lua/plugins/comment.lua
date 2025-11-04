return {
    "numToStr/Comment.nvim",
    config = function ()
        require("Comment").setup {
            pre_hook = function (ctx)
                return vim.bo.commentstring
            end,
        }
    end,
}
