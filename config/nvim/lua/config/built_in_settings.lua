local M = {}

M.set_leaders = function()
    -- We need this before we load lazy.nvim
    vim.g.mapleader = " "
    vim.g.maplocalleader = ","
end


local function set_builtins()
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

    -- Wait for a key combination longer. Helps figuring out longer combinations.
    -- By default timeoutlen is 1000 ms.
    vim.o.timeoutlen = 2000

    -- Tab size
    vim.o.tabstop = 4
    vim.bo.tabstop = 4
    vim.o.shiftwidth = 4
    vim.bo.shiftwidth = 4
    vim.o.expandtab = true
    vim.bo.expandtab = true

    -- When scrolling past a multiline, wrapped line, allows moving in between the wrapped visual lines.
    vim.o.smoothscroll = true

    -- Line length. This affects `gww`.
    vim.opt.textwidth = 120

    -- Notable breaking options:
    -- * "t": insert newline when exceeding textwidth in insert mode. Formatting for text. Doesn't affect comments.
    -- * "c": like "t", but for comments. With comment line leader. Doesn't affect non-comments.
    -- * "r": insert comment leader on enter in insert mode. Undo with <C-u>.
    -- * "q": format comments with "gq".
    -- * "n": recognize numbered lists. Insert appropriate leading margin when wrapping text.
    -- * "1": don't break after 1-letter word.
    -- * "j": remove comment leader when joining lines.
    --
    -- In general, "t" is useful for prose, "c" is useful for source code.
    --
    -- Usual default: "tcqj". Actual default depends on the settings in the filetype script.
    --
    -- The following config should be sensible for comments in source code, and markdown. Now, `gq` and `gw` can be used
    -- to both split _and_ join lines. Even editing a line live makes it automatically re-break. Neat!
    vim.opt.formatoptions = "crqn1j"

    -- When an operation is risky, ask for confirmation instead of failing by default.
    vim.o.confirm = true

    -- Show line numbers
    vim.o.number = true
    vim.wo.number = true

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

    -- Show horizontal line at cursor row.
    vim.opt.cursorline = true

    -- Show diagnostic errors as virtual text under the offender code line. Defaults to just underline + signcolumn
    -- icon.
    vim.diagnostic.config({ float = true, virtual_text = true, update_in_insert = true })

    -- Always show sign column. Otherwise, it would appear and disappear whenever entering
    -- and exiting insert mode in a markdown file with spelling issues.
    vim.opt.signcolumn = "yes"

    -- Make the `/` buffer search case insensitive unless the pattern includes at
    -- least one capital letter.
    vim.opt.ignorecase = true
    vim.opt.smartcase = true

    -- Make `:find` work recursively. Override the built-in default ("/usr/include").
    vim.opt.path = "**"

    -- Disable swapfiles. Fixes opening the same file from multiple vims.
    vim.opt.swapfile = false

    -- Tell neovim plugins written in Python use the default interpreter. Helps with virtual environments.
    -- src: https://github.com/tweekmonster/nvim-python-doctor/wiki/Simple-Installation
    vim.cmd [[let g:python3_host_prog = 'python']]

    -- Use conceal in general.
    vim.opt.conceallevel = 1

    -- Show border with rounded corners on floating windows, like the LSP hover popup.
    vim.o.winborder = "rounded"
end


local function ft_autocmds()
    local aj_ft_autocmds = vim.api.nvim_create_augroup("aj-ft-autocmds", { clear = true })

    -- Enable comments in .sql files.
    vim.api.nvim_create_autocmd("FileType", {
        pattern = "sql",
        command = "setlocal commentstring=--\\ %s",
        group = aj_ft_autocmds,
    })

    -- Enable comments in .beancount files.
    vim.api.nvim_create_autocmd("FileType", {
        pattern = "beancount",
        command = "setlocal commentstring=;\\ %s",
        group = aj_ft_autocmds,
    })

    local python = function()
        -- Set line width to 120 instead of 79. Affects `gww`.
        vim.api.nvim_create_autocmd("Filetype", {
            group = aj_ft_autocmds,
            pattern = { "python" },
            callback = function()
                vim.opt_local.textwidth = 120
            end,
        })
    end
    python()

    local cpp = function()
        -- Use // ... instead of /* ... */
        vim.api.nvim_create_autocmd("Filetype", {
            group = aj_ft_autocmds,
            pattern = { "cpp" },
            command = "setlocal commentstring=//%s",
        })
    end
    cpp()

    local yaml = function()
        -- Set indent size to 2 instead of 4
        vim.api.nvim_create_autocmd("Filetype", {
            group = aj_ft_autocmds,
            pattern = { "yaml" },
            command = "setlocal shiftwidth=2",
        })

    end
    yaml()

    local helm = function()
        vim.api.nvim_create_autocmd("Filetype", {
            group = aj_ft_autocmds,
            pattern = { "helm" },
            callback = function ()
                -- Set indent size to 2 instead of 4
                vim.bo.shiftwidth = 2
                -- Set comment string for Helm templates
                vim.bo.commentstring = "{{/* %s */}}"
            end
        })

        -- Register helm as the filetype for yamls in specific dirs.
        vim.filetype.add {
            pattern = {
                [".*/manifests/.*.yaml"] = "helm",
                [".*/manifests/.*.tpl"] = "helm",
                [".*/templates/.*.yaml"] = "helm",
                [".*/templates/.*.tpl"] = "helm",
                [".*/helm/.*.yaml"] = "helm",
                [".*/helm/.*.tpl"] = "helm",
                [".*.yaml.gotmpl"] = "helm",
                [".*/.*values.*.yaml"] = "helm",
            }
        }
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
    end
    hujson()

    local markdown = function()
        vim.api.nvim_create_autocmd("Filetype", {
            group = aj_ft_autocmds,
            pattern = { "markdown" },
            callback = function(ev)
                vim.opt_local.textwidth = 100
            end,
        })
    end
    markdown()

    local html = function()
        -- Set indent size to 2 instead of 4
        vim.api.nvim_create_autocmd("Filetype", {
            group = aj_ft_autocmds,
            pattern = { "html" },
            command = "setlocal shiftwidth=2",
        })
    end
    html()

    local typescript = function()
        -- Set indent size to 2 instead of 4
        vim.api.nvim_create_autocmd("Filetype", {
            group = aj_ft_autocmds,
            pattern = { "typescript,typescriptreact" },
            command = "setlocal shiftwidth=2",
        })
    end
    typescript()
end


local function general_autocmds()
    local aj_general_autocmds = vim.api.nvim_create_augroup("aj-general-autocmds", { clear = true })

    -- Automatically resize nvim windows when the terminal OS window resizes.
    vim.api.nvim_create_autocmd("VimResized", {
        callback = function()
            vim.cmd("wincmd =")
        end,
        group = aj_general_autocmds,
    })
end


M.setup = function()
    set_builtins()
    ft_autocmds()
    general_autocmds()
end


return M
