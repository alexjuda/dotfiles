local M = {}

function M.setup()
    -- Bootstrap lazy.nvim
    local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
    if not (vim.uv or vim.loop).fs_stat(lazypath) then
        local lazyrepo = "https://github.com/folke/lazy.nvim.git"
        print("Cloning " .. lazyrepo .. " to " .. lazypath .. "...")
        local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
        if vim.v.shell_error ~= 0 then
            vim.api.nvim_echo({
                { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
                { out,                            "WarningMsg" },
                { "\nPress any key to exit..." },
            }, true, {})
            vim.fn.getchar()
            os.exit(1)
        end
        print("Cloned.")
    end
    vim.opt.rtp:prepend(lazypath)

    -- Make sure to setup `mapleader` and `maplocalleader` before
    -- loading lazy.nvim so that mappings are correct.
    -- TODO: check if mapleader is set or issue warning

    -- Setup lazy.nvim
    require("lazy").setup({
        spec = {
            -- Name of the directory where I keep my plugin specs.
            { import = "plugins" },
        },
        -- colorscheme that will be used when installing plugins.
        install = { colorscheme = { "catppuccin" } },
        change_detection = {
            -- I often reload nvim after config edit anyway.
            enabled = false,
            -- Don't spam :messages.
            notify = false,
        },
    })
end

return M
