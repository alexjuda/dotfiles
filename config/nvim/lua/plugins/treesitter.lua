local langs = {
    "bash",
    "beancount",
    "css",
    "csv",
    "dot",
    "git_config",
    "git_rebase",
    "gitattributes",
    "gitcommit",
    "gitignore",
    "go",
    "helm",
    "html",
    "javascript",
    "jinja",
    "json",
    "lua",
    "make",
    "markdown",
    "markdown_inline",
    "python",
    "requirements",
    "sql",
    "terraform",
    "toml",
    "tsx",
    "typescript",
    "yaml",
}


return {
    "nvim-treesitter/nvim-treesitter",
    -- treesitter doesn't support lazy-loading.
    lazy = false,
    branch = "main",
    build = ":TSUpdate",
    config = function(opts)
        local ts = require("nvim-treesitter")
        ts.setup(opts)

        vim.api.nvim_create_user_command("TSInstallRegistered", function()
            ts.install(langs, { summary = true })
        end, { desc = "Install grammars I have defined in my config" })

        local group = vim.api.nvim_create_augroup("aj-treesitter", {})
        vim.api.nvim_create_autocmd("FileType", {
            group = group,
            pattern = langs,
            callback = function()
                vim.treesitter.start()

                -- Use treesitter for folds.
                vim.wo.foldmethod = "expr"
                vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'

                -- Don't alter the contents of the fold title line.
                vim.wo.foldtext = ""

                -- Prevent folding everything whenever opening a code file.
                vim.wo.foldlevel = 99

                -- Show a nice TUI for folds on the left.
                vim.wo.foldcolumn = "1"

                -- Use treesitter for indents. This doesn't work at the time.
                -- vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            end,
        })
    end
}
