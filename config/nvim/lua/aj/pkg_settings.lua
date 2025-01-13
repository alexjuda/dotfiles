local M = {}


local setup_all = function()
    ---------------
    -- which-key --
    ---------------
    require("which-key").setup {}


    -----------------------------
    -- nvim-search-and-replace --
    -----------------------------
    require("nvim-search-and-replace").setup()


    -------------------
    -- zen-mode.nvim --
    -------------------
    require("zen-mode").setup {
        window = {
            -- Use just a little over the standard 80 line char limit to account
            -- for the line numbers. We can also use a fraction of the outer
            -- window size.
            -- width = 0.85,
            width = 90,
            -- Don't shade the backgrop of the Zen window.
            -- backdrop = 0.95,
            backdrop = 1.0
        },
    }


    ------------
    -- Colors --
    ------------
    -- Without this, moonfly uses old vi colors.
    -- vim.o.termguicolors = true

    -- Without this, moonfly uses gray blocks for window separators.

    -- require('ayu').setup({
    --     mirage = false, -- Set to `true` to use `mirage` variant instead of `dark` for dark background.
    --     overrides = {}, -- A dictionary of group names, each associated with a dictionary of parameters (`bg`, `fg`, `sp` and `style`) and colors in hex.
    -- })
    -- require('ayu').colorscheme()

    vim.cmd.colorscheme "catppuccin"

    ----------------
    -- Treesitter --
    ----------------

    -- General config --
    -------------------------------

    -- Enable all common functionality

    require("nvim-treesitter.configs").setup {
        modules = {},

        ensure_installed = {
            "bash",
            "csv",
            "cpp",
            "diff",
            "dockerfile",
            "gitattributes",
            "git_config",
            "git_rebase",
            "gitcommit",
            "gitignore",
            "helm",
            "html",
            "http",
            "javascript",
            "json",
            "lua",
            "make",
            "markdown",
            "markdown_inline",
            "mermaid",
            "python",
            "requirements",
            "rst",
            "sql",
            "toml",
            "tsx",
            "typescript",
            "vimdoc",
            "yaml",
        },

        sync_install = true,

        auto_install = false,

        ignore_install = {},

        highlight = {
            enable = true,
        },

        indent = {
            enable = false,
        },

        -- tree-sitter objects for code navigation
        textobjects = {
            move = {
                enable = true,
                set_jumps = true,

                goto_previous_start = {
                    ["[p"] = "@parameter.inner",
                    ["[f"] = "@function.outer",
                    ["[k"] = "@class.outer",
                    ["[i"] = "@call.outer",
                },
                goto_previous_end = {
                    ["[P"] = "@parameter.outer",
                    ["[F"] = "@function.outer",
                    ["[K"] = "@class.outer",
                    ["[I"] = "@call.outer",
                },
                goto_next_start = {
                    ["]p"] = "@parameter.inner",
                    ["]f"] = "@function.outer",
                    ["]k"] = "@class.outer",
                    ["]i"] = "@call.outer",
                },
                goto_next_end = {
                    ["]P"] = "@parameter.outer",
                    ["]F"] = "@function.outer",
                    ["]K"] = "@class.outer",
                    ["]I"] = "@call.outer",
                },
            },

            select = {
                enable = true,

                -- Automatically jump forward to textobj, similar to targets.vim
                lookahead = true,

                keymaps = {
                    -- You can use the capture groups defined in textobjects.scm
                    ["af"] = "@function.outer",
                    ["if"] = "@function.inner",
                    ["ai"] = "@call.outer",
                    ["ii"] = "@call.inner",
                    ["ak"] = "@class.outer",
                    ["ik"] = "@class.inner",
                    ["ap"] = "@parameter.outer",
                    ["ip"] = "@parameter.inner",
                },
            },
        },
    }

    -- Use treesitter for folds
    vim.opt.foldmethod = "expr"
    vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    vim.opt.foldtext = "v:lua.vim.treesitter.foldtext()"
    -- Prevent folding everything whenever opening a code file.
    vim.opt.foldlevel = 99

    ----------
    -- LLMs --
    ----------
    -- See https://github.com/zbirenbaum/copilot.lua?tab=readme-ov-file#setup-and-configuration for keybindings.
    require('copilot').setup({
        suggestion = {
            auto_trigger = true,
        },
        filetypes = {
            gitcommit = true,
            yaml = true,
        },
    })

    --------------------
    -- Autocompletion --
    --------------------
    local cmp = require("cmp")

    -- setup nvim-cmp
    cmp.setup({
        snippet = {
            -- REQUIRED - you must specify a snippet engine
            expand = function(args)
            end,
        },
        mapping = cmp.mapping.preset.insert({
            ['<C-Space>'] = cmp.mapping.complete(),
            ['<C-e>'] = cmp.mapping.abort(),
            ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        }),
        sources = cmp.config.sources({
            { name = 'nvim_lsp' },
        }),
        -- Don't show the text like "Function" after the symbol
        -- src: https://github.com/hrsh7th/nvim-cmp#how-to-show-name-of-item-kind-and-source-like-compe
        formatting = {
            format = require("lspkind").cmp_format({
                with_text = false,
            }),
        },
    })

    ---------------
    -- Telescope --
    ---------------
    require("telescope").setup {
        defaults = {
            mappings = {
                n = {
                    ["<C-X>"] = require("telescope.actions").delete_buffer,
                },
                i = {
                    ["<C-X>"] = require("telescope.actions").delete_buffer,
                },
            },
        },
    }


    -----------------
    -- Status line --
    -----------------

    -- Based on:
    -- * https://www.reddit.com/r/neovim/comments/ojnie2/comment/h52uy92/?utm_source=share&utm_medium=web2x&context=3
    -- * https://github.com/hoob3rt/lualine.nvim#custom-components
    local function breadcrumbs()
        return require("lspsaga.symbol.winbar").get_bar() or require("nvim-treesitter").statusline()
    end

    -- Simulates how Emacs shows currently active minor modes on the status line.
    local function minor_mode_status()
        local status = ""
        if (vim.inspect(vim.b.venn_enabled) ~= "nil") then
            status = status .. "V"
        end
        return status
    end

    require("lualine").setup {
        sections = {
            lualine_a = {
                {
                    -- Show buffer number using the vim status line format:
                    -- https://vimdoc.sourceforge.net/htmldoc/options.html#'statusline'
                    "%n",

                    separator = { left = "", right = "" },
                },
            },
            lualine_b = {
                {
                    "filename",
                    -- Show relative path.
                    path = 1,

                    -- Show symbols after the filepath. Src: https://github.com/nvim-lualine/lualine.nvim#buffers-component-options
                    symbols = {
                        modified = ' ●', -- Text to show when the buffer is modified
                        alternate_file = '#', -- Text to show to identify the alternate file
                        directory = '', -- Text to show when the buffer is a directory
                    },
                }
            },
            -- Don't show file name again.
            lualine_c = {},
            lualine_x = {
                minor_mode_status,
                {
                    "diagnostics",
                    sources = { "nvim_diagnostic", },
                },
                "fileformat",
                "filetype",
            },
            lualine_y = {
                "searchcount",
                "progress",
            },
            lualine_z = {
                {
                    "selectioncount",
                    -- Override default separators.
                    separator = { left = "", right = "" },
                },
                {
                    "location",
                    -- Override default separators.
                    separator = { left = "", right = "" },
                },
            }
        },
        winbar = {
            lualine_c = { breadcrumbs },
        },
    }


    ---------------------
    -- Show signatures --
    ---------------------
    require("lsp_signature").setup {
        -- show signature in the middle of multi-line invocations
        always_trigger = true,
    }

    ---------------------
    -- Symbols sidebar --
    ---------------------
    require("aerial").setup {}


    ---------------------------------------
    -- Breadcrumbs and other nice things --
    ---------------------------------------

    require("lspsaga").setup {
        -- By default, there's a lightbulb for each line there are code actions
        -- for. Unfortunately, this overloads LSPs when scrolling fast.
        lightbulb = { enable = false },
    }


    -----------------------------------
    -- Close buffers after some time --
    -----------------------------------

    require("early-retirement").setup {
        -- Default: 20 min.
        retirementAgeMins = 5,
    }

    -----------------------
    -- Project File Tree --
    -----------------------
    -- Unless you are still migrating, remove the deprecated commands from v1.x
    vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

    -- If you want icons for diagnostic errors, you'll need to define them somewhere:
    vim.fn.sign_define("DiagnosticSignError",
        { text = " ", texthl = "DiagnosticSignError" })
    vim.fn.sign_define("DiagnosticSignWarn",
        { text = " ", texthl = "DiagnosticSignWarn" })
    vim.fn.sign_define("DiagnosticSignInfo",
        { text = " ", texthl = "DiagnosticSignInfo" })
    vim.fn.sign_define("DiagnosticSignHint",
        { text = "", texthl = "DiagnosticSignHint" })

    require("neo-tree").setup {
        filesystem = {
            -- Let dirbuf handle editing directories.
            hijack_netrw_behavior = "disabled",
        },
    }

    -----------------
    -- Git goodies --
    -----------------
    require("gitsigns").setup {}

    ---------------------
    -- Highlight TODOs --
    ---------------------
    require("todo-comments").setup {
        highlight = {
            pattern = {
                 -- example: 'TODO: abc'
                [[.*<(KEYWORDS)\s*:]],
                 -- example: 'TODO (JIRA-123): abc'
                [[.*<((KEYWORDS)\s*\(.*\)*)\s*:]],
            },
        },
    }

    -----------------------------------
    -- Highlight symbol under cursor --
    -----------------------------------
    require("illuminate").configure {}

    ----------------------------------
    -- Show animations when yanking --
    ----------------------------------
    require("tiny-glimmer").setup {}


    -----------
    -- Jumps --
    -----------
    require("hop").setup {}

    -----------
    -- Notes --
    -----------
    require("aj.vapor").setup {
        scratch_dir = "~/Documents/notes-synced/daily",
        todo_dir = "~/Documents/notes-synced/todo",
    }

    ------------------
    -- Autocommands --
    ------------------

    ------------------------------
    -- Filetype-specific config --
    ------------------------------

    -- Markdown --
    --------------
    vim.g.markdown_folding = true

    require("easytables").setup {}

    -- C++ --
    ---------
    -- Use // ... instead of /* ... */
    local use_line_comments = "aj-use-line-comments"
    vim.api.nvim_create_augroup(use_line_comments, { clear = true })
    vim.api.nvim_create_autocmd("Filetype", {
        group = use_line_comments,
        pattern = { "cpp" },
        command = "setlocal commentstring=//%s",
    })

    -- YAML --
    ----------
    -- Customize indent size
    local set_indent_autocmd = "aj-set-indent-width"
    vim.api.nvim_create_augroup(set_indent_autocmd, { clear = true })
    vim.api.nvim_create_autocmd("Filetype", {
        group = set_indent_autocmd,
        pattern = { "yaml" },
        command = "setlocal shiftwidth=2",
    })

    -- HTML --
    ----------
    -- Customize indent size
    vim.api.nvim_create_autocmd("Filetype", {
        group = set_indent_autocmd,
        pattern = { "html" },
        command = "setlocal shiftwidth=2",
    })

    -- TypeScript --
    -- Customize indent size
    vim.api.nvim_create_autocmd("Filetype", {
        group = set_indent_autocmd,
        pattern = { "typescript,typescriptreact" },
        command = "setlocal shiftwidth=2",
    })
end


M.setup = function()
    setup_all()
end

return M
