local M = {}


M.setup = function()
    --------
    -- UI --
    --------

    -- Buffer- or window-local options that we want to provide defaults for need
    -- to be set both globally and "locally".
    -- See https://oroques.dev/notes/neovim-init/#set-options

    -- Make splits happen at the other part of the screen
    vim.o.splitbelow = true
    vim.o.splitright = true

    -- Use point system clipboard to the default register
    vim.o.clipboard = "unnamedplus"

    -- Speed up firing up the WhichKey pane.
    -- By default timeoutlen is 1000 ms.
    vim.o.timeoutlen = 200

    -- Tab size
    vim.o.tabstop = 4
    vim.bo.tabstop = 4
    vim.o.shiftwidth = 4
    vim.bo.shiftwidth = 4
    vim.o.expandtab = true
    vim.bo.expandtab = true

    -- Ask for confirmation instead of failing by default
    vim.o.confirm = true

    -- Show at least one more line when scrolling
    vim.o.scrolloff = 8
    vim.wo.scrolloff = 8

    -- Show line numbers
    vim.o.number = true
    vim.wo.number = true

    -- Add some left margin
    vim.o.numberwidth = 6
    vim.wo.numberwidth = 6

    -- Enable scrolling with mouse
    vim.o.mouse = "a"

    -- Improve experience with nvim-completion
    -- Config taken from: https://github.com/hrsh7th/nvim-cmp#recommended-configuration
    -- Lua syntax: https://neovim.io/doc/user/lua-guide.html#_-vim.opt
    -- vim.opt.completeopt = { "menu", "menuone", "noselect" }

    -- Switch buffers without saving
    vim.o.hidden = true

    -- Show trailing spaces & tabs.
    vim.o.list = true
    vim.wo.list = true

    -- Don't soft wrap in the middle of a word
    vim.o.linebreak = true

    -- Disable the bottom line with mode name like "-- INSERT --". Status line
    -- already provides this information.
    vim.o.showmode = false

    -- Set langauge
    vim.cmd [[language en_US.UTF-8]]

    -- Hide command line if not currently writing a command. Works with neovim >=0.8.
    vim.o.cmdheight = 0

    -- Show horizontal line at cursor row.
    vim.opt.cursorline = true

    -- Show gitsigns & diagnostics over the line numbers. There's an issue where the status
    -- line background isn't applied to the sign column. This setting makes it a little
    -- less annoying. See also: https://github.com/lewis6991/gitsigns.nvim/issues/563
    -- vim.opt.signcolumn = "number"

    -- Always show sign column. Otherwise, it would appear and disappear whenever entering
    -- and exiting insert mode in a markdown file with spelling issues.
    vim.opt.signcolumn = "yes"

    -- Make the `/` buffer search case insensitive unless the pattern includes at
    -- least one capital letter.
    vim.opt.ignorecase = true
    vim.opt.smartcase = true

    -- Show backlighted column separator on the right.
    vim.opt.colorcolumn = "120"

    -- Make `:find` work recursively. Override the built-in default ("/usr/include").
    vim.opt.path = "**"

    -- Disable swapfiles. Fixes opening the same file from multiple vims.
    vim.opt.swapfile = false

    -- Tell neovim plugins written in Python use the default interpreter. Helps with virtual environments.
    -- src: https://github.com/tweekmonster/nvim-python-doctor/wiki/Simple-Installation
    vim.cmd [[let g:python3_host_prog = 'python']]

    -- Hide backticks, links, and fenced blocks in markdown.
    vim.opt.conceallevel = 2

    -- Enable comments in .sql files.
    local ft_sql = vim.api.nvim_create_namespace("ft_sql")
    vim.api.nvim_create_autocmd("FileType", {
        pattern = "sql",
        command = "setlocal commentstring=--\\ %s",
        group = ft_sql,
    })

    -- Enable comments in .beancount files.
    local ft_beancount = vim.api.nvim_create_namespace("ft_beancount")
    vim.api.nvim_create_autocmd("FileType", {
        pattern = "beancount",
        command = "setlocal commentstring=;\\ %s",
        group = ft_beancount,
    })
end


return M
