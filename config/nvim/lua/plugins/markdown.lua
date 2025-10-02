return {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.icons" },
    lazy = true,
    ft = "markdown",
    ---@module "render-markdown"
    ---@type render.md.UserConfig
    opts = {
        heading = {
            -- Heandings are too confusing.
            enabled = false,
            -- By default, headings would get a full-line bar.
            -- width = "block",
            -- left_pad = 1,
            -- right_pad = 1,
            -- border = true,
            -- -- Make all the headings symmetric in shape.
            -- position = "inline",
        },
        code = {
            -- Defaults to concealing the bottom ```. Switching between insert and normal modes causes the whole
            -- page to flicker, which is super annoying.
            border = "thin",
        },
        checkbox = {
            -- Show bullet before the checkbox. Improves layout for nested lists.
            bullet = true,
            unchecked = {
                -- Add space prefix to stabilize the layout.
                icon = " 󰄱 ",
            },
            checked = {
                -- Add space prefix to stabilize the layout.
                icon = ' 󰱒 ',
            },
        },
        link = {
            -- Disable showing icons in front of URLs.
            enabled = false,
        },
        win_options = {
            conceallevel = {
                -- Hide backticks, links, and fenced blocks in markdown (level > 0). On the other hand, don't change the horizontal
                -- placement of letters (level < 2).
                rendered = 1,
            }
        },
    },
}
