-- Utilities for switching config opts depending on the environment I'm running in.

M = {}

M.on_mac = function()
    return vim.fn.has("macunix") == 1
end


M.on_linux = function()
    return not M.on_mac()
end

return M
