-- My custom commands for functions I want to run interactively.
local M = {}


M.setup = function()
   vim.api.nvim_create_user_command("DelAllMarks", "delm! | delm A-Z0-9", {})
end


return M
