return {
    {
        "Shatur/neovim-ayu",
        -- This is my main colorscheme. Need to always load it.
        lazy = false,
        config = function()
            local colors = require("ayu.colors")
            local mirage = true
            colors.generate(mirage)

            -- Adjust gutter colors:
            -- 1. Make the full cursor line have the same background, even on the gutter.
            -- 2. Tone down fold markers. I don't use it often.
            local cursor_line_bg = { bg = colors.line }
            local line_nr_fg = { fg = colors.guide_normal }
            require("ayu").setup {
                overrides = {
                    CursorLineFold = cursor_line_bg,
                    CursorLineSign = cursor_line_bg,
                    FoldColumn = line_nr_fg
                },
            }
            vim.cmd.colorscheme "ayu-mirage"
        end
    },
}
