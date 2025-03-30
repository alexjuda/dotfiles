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

    -- Line length. This affects `gww`.
    vim.opt.textwidth = 120

    -- Notable breaking options:
    -- * "t": insert newline when exceeding textwidth in insert mode. Formatting for text. Doesn't affect comments.
    -- * "c": like "t", but for comments. With comment line leader. Doesn't affect non-comments.
    -- * "r": insert comment leader on enter in insert mode. Undo with <C-u>.
    -- * "q": format comments with "gq".
    -- * "a": automated paragraph formatting. Every edit means the paragraph is reformatted.
    -- * "n": recognize numbered lists. Insert appropriate leading margin when wrapping text.
    -- * "1": don't break after 1-letter word.
    -- * "j": remove comment leader when joining lines.
    -- * "p": remove comment leader when joining lines.
    --
    -- In general, "t" is useful for prose, "c" is useful for source code.
    --
    -- Usual default: "tcqj". Actual default depends on the settings in the filetype script.
    --
    -- The following config should be sensible for comments in source code, and markdown. Now, `gq` and `gw` can be used
    -- to both split _and_ join lines. Even editing a line live makes it automatically re-break. Neat!
    vim.opt.formatoptions = "crqan1jp"

    -- When an operation is risky, ask for confirmation instead of failing by default.
    vim.o.confirm = true

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

    -- Wrapped lines should be indented.
    vim.o.breakindent = true

    -- Indent wrapped lines to match the parent, taking into account list markers.
    vim.o.breakindentopt = "list:-1"

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

    local python = function()
        local aj_python = "aj-python"
        vim.api.nvim_create_augroup(aj_python, { clear = true })
        -- Set line width to 120 instead of 79. Affects `gww`.
        vim.api.nvim_create_autocmd("Filetype", {
            group = aj_python,
            pattern = { "python" },
            callback = function()
                vim.opt_local.textwidth = 120
            end,
        })
    end
    python()

    local cpp = function()
        local aj_cpp = "aj-cpp"
        vim.api.nvim_create_augroup(aj_cpp, { clear = true })
        -- Use // ... instead of /* ... */
        vim.api.nvim_create_autocmd("Filetype", {
            group = aj_cpp,
            pattern = { "cpp" },
            command = "setlocal commentstring=//%s",
        })
    end
    cpp()

    local yaml = function()
        local aj_yaml = "aj-yaml"
        vim.api.nvim_create_augroup(aj_yaml, { clear = true })

        -- Set indent size to 2 instead of 4
        vim.api.nvim_create_autocmd("Filetype", {
            group = aj_yaml,
            pattern = { "yaml" },
            command = "setlocal shiftwidth=2",
        })

        -- Register helm as the filetype for yamls in specific dirs.
        vim.filetype.add {
            pattern = {
                [".*/manifests/.*.yaml"] = "helm",
                [".*/manifests/.*.tpl"] = "helm",
            }
        }
    end
    yaml()

    local helm = function()
        local aj_helm = "aj-helm"
        vim.api.nvim_create_augroup(aj_helm, { clear = true })
        -- Set indent size to 2 instead of 4
        vim.api.nvim_create_autocmd("Filetype", {
            group = aj_helm,
            pattern = { "helm" },
            command = "setlocal shiftwidth=2",
        })
    end
    helm()

    local hujson = function()
        -- Register additional extension for the hjson filetype. And set comment string.
        vim.filetype.add {
            extension = {
                hujson = function(path, bufnr)
                    return "hjson", function(bufnr)
                        vim.bo[bufnr].commentstring = "// %s"
                    end
                end,
            },
        }
        -- Fix missing comment string.
    end
    hujson()

    local markdown = function()
        local aj_markdown = "aj-markdown"
        vim.api.nvim_create_augroup(aj_markdown, { clear = true })
        vim.api.nvim_create_autocmd("Filetype", {
            group = aj_markdown,
            pattern = { "markdown" },
            callback = function(ev)
                vim.opt_local.formatoptions = "crqan1jp"
            end,
        })
    end
    markdown()

    local html = function()
        local aj_html = "aj-html"
        vim.api.nvim_create_augroup(aj_html, { clear = true })
        -- Set indent size to 2 instead of 4
        vim.api.nvim_create_autocmd("Filetype", {
            group = aj_html,
            pattern = { "html" },
            command = "setlocal shiftwidth=2",
        })
    end
    html()

    local typescript = function()
        local aj_ts = "aj-ts"
        vim.api.nvim_create_augroup(aj_ts, { clear = true })
        -- Set indent size to 2 instead of 4
        vim.api.nvim_create_autocmd("Filetype", {
            group = aj_ts,
            pattern = { "typescript,typescriptreact" },
            command = "setlocal shiftwidth=2",
        })
    end
    typescript()
end


return M
