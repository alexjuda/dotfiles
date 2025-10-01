local common = require("aj.lsp.common")

local M = {}


local function read_dict_words()
    -- Workaround for ltex-ls not reading/writing dict files.

    local path = vim.env.HOME .. "/.local/share/lang-servers/ltex-ls-data/dict.txt"

    local f = io.open(path)
    if f == nil then
        print("Warning: dict file doesn't exist at" .. path)
        return {}
    end
    io.close(f)

    local lines = {}
    for line in io.lines(path) do
        lines[#lines + 1] = line
    end

    return lines
end


M.setup = function()
    -- LaTeX & Markdown linter based on LanguageTool.

    -- Assumes that `ltex-ls` is installed and is available in the $PATH.
    -- Install from a release from: https://github.com/valentjn/ltex-ls/releases.

    vim.lsp.config("ltex", {
        on_attach = common.shared_on_attach,
        settings = {
            ltex = {
                dictionary = {
                    ["en-US"] = read_dict_words(),
                },
            },
        },
    })

    vim.lsp.enable("ltex")
end


return M
