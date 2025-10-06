-- GPT prompt AI plugin.
return {
    "robitx/gp.nvim",
    dependencies = { "zbirenbaum/copilot.lua" },
    lazy = true,
    opts = {
        providers = {
            openai = {
                -- Enabled by default.
                disable = true,
            },
            copilot = {
                -- Disabled by default.
                disable = false,
                -- Reads copilot token from a file.
            },
        },
    },
    cmd = {
        "GpAppend",
        "GpChatFinder",
        "GpChatNew",
        "GpChatPaste",
        "GpChatToggle",
        "GpContext",
        "GpEnew",
        "GpImplement",
        "GpNew",
        "GpNextAgent",
        "GpPopup",
        "GpPrepend",
        "GpRewrite",
        "GpSelectAgent",
        "GpStop",
        "GpTabnew",
        "GpVnew",
        "GpWhisper",
        "GpWhisperAppend",
        "GpWhisperEnew",
        "GpWhisperNew",
        "GpWhisperPopup",
        "GpWhisperPrepend",
        "GpWhisperRewrite",
        "GpWhisperTabnew",
        "GpWhisperVnew",
    },
}
