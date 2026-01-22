-- Leaders have to be set before lazy.nvim.
require("config.built_in_settings").set_leaders()
-- We need lazy.nvim for the testing plugins.
require("config.lazy").setup()

-- Only execute my actual configs in interactive mode. Enables isolated unit testing.
if #vim.api.nvim_list_uis() > 0 then
    require("config.built_in_settings").setup()
    require("config.maps").setup()
    require("config.lsp").setup()
end
