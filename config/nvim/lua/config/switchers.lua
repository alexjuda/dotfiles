-- Utilities for switching config opts depending on the environment I'm running in.

M = {}


function M.on_mac()
    return vim.fn.has("macunix") == 1
end


function M.on_linux()
    return not M.on_mac()
end


return M
