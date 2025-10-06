return {
    "chrisgrieser/nvim-early-retirement",
    opts = {
        -- Default: 20 min.
        retirementAgeMins = 5,

        -- Ignore buffers with unsaved changes. If false, the buffers will
        -- automatically be written and then closed.
        ignoreUnsavedChangesBufs = false,

        -- Ignore non-empty buftypes, for example terminal buffers
        ignoreSpecialBuftypes = true,

        -- When a file is deleted, for example via an external program, delete the
        -- associated buffer as well. Requires Neovim >= 0.10.
        -- (This feature is independent from the automatic closing)
        deleteBufferWhenFileDeleted = false,

        -- Need to include the default values as well because the typing in this package causes LSP to complain.
        ignoredFiletypes = {},
        ignoreFilenamePattern = "",
        ignoreAltFile = true,
        minimumBufferNum = 1,
        ignoreVisibleBufs = true,
        ignoreUnloadedBufs = false,
        notificationOnAutoClose = false,
        deleteFunction = vim.nvim_buf_delete,
    },
    event = "VeryLazy",
}
