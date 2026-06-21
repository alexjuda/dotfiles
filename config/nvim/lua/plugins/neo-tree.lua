return {
    "nvim-neo-tree/neo-tree.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        "nvim-tree/nvim-web-devicons",
    },
    branch = "v3.x",
    lazy = true,
    cmd = { "Neotree", },
    opts = {
        filesystem = {
            filtered_items = {
                visible = true,
            },
            follow_current_file = {
                enabled = true,
                leave_dirs_open = false,
            },
        },
    },
}
