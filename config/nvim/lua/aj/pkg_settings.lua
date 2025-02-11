local M = {}


local setup_all = function()
    local which_key = function()
        require("which-key").setup {}
    end
    which_key()

    local nvim_search_and_replace = function()
        require("nvim-search-and-replace").setup()
    end
    nvim_search_and_replace()

    local zen_mode = function()
        require("zen-mode").setup {
            window = {
                backdrop = 1.0,
                width = 80,
                options = {
                    signcolumn = "no",
                    number = false,
                    cursorline = false,
                    foldcolumn = "0",
                },
            },
        }

        -- Workaround margin background color being just plain black.
        -- Source: https://www.reddit.com/r/neovim/comments/1fmuue9/comment/m8bf88j/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
        vim.api.nvim_set_hl(0, "ZenBg", { bg = "NONE" })
    end
    zen_mode()

    local colors = function()
        vim.cmd.colorscheme "catppuccin"
    end
    colors()

    local treesitter = function()
        -- Enable all common functionality
        require("nvim-treesitter.configs").setup {
            modules = {},

            ensure_installed = {
                "bash",
                "beancount",
                "cpp",
                "csv",
                "diff",
                "dockerfile",
                "git_config",
                "git_rebase",
                "gitattributes",
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

        -- Settings based on https://www.jackfranklin.co.uk/blog/code-folding-in-vim-neovim/
        -- Use treesitter for folds.
        vim.opt.foldmethod = "expr"
        vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"

        -- Don't alter the contents of the fold title line.
        vim.opt.foldtext = ""

        -- Prevent folding everything whenever opening a code file.
        vim.opt.foldlevel = 99

        -- Show a nice TUI for folds on the left.
        vim.opt.foldcolumn = "1"
    end
    treesitter()

    local function llms()
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
    end
    -- Uncomment to enable using Copilot
    -- llms()

    local autocompletion = function()
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
    end
    autocompletion()

    local telescope = function()
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
    end
    telescope()

    local status_line = function()
        -- Based on:
        -- * https://www.reddit.com/r/neovim/comments/ojnie2/comment/h52uy92/?utm_source=share&utm_medium=web2x&context=3
        -- * https://github.com/hoob3rt/lualine.nvim#custom-components
        local function breadcrumbs()
            local lsp_winbar = require("lspsaga.symbol.winbar").get_bar()
            local ts_winbar = require("nvim-treesitter").statusline()
            -- The last bit is a workaround for `nil`. If a `nil` is returned
            -- here, it shows up as "nil" on the winbar. However, there's also
            -- `draw_empty = false` option, which hides the winbar altogether.
            return lsp_winbar or ts_winbar or ""
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
            options = {
                -- Don't use the square separators.
                component_separators = { left = "", right = "" },
                section_separators = { left = "", right = "", },
                disabled_filetypes = {
                    statusline = { "neo-tree", },
                },
            },
            sections = {
                lualine_a = {
                    {
                        -- Show buffer number using the vim status line format:
                        -- https://vimdoc.sourceforge.net/htmldoc/options.html#'statusline'
                        "%n",
                    },
                },
                -- Don't show the gray bar.
                lualine_b = {},
                lualine_c = {
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
                    },
                    {
                        "location",
                    },
                }
            },
            winbar = {
                lualine_c = { breadcrumbs },
            },
        }
    end
    status_line()


    local lsp_signature = function()
        require("lsp_signature").setup {
            -- show signature in the middle of multi-line invocations
            always_trigger = true,
        }
    end
    lsp_signature()

    local aerial = function()
        -- Symbols sidebar
        require("aerial").setup {}
    end
    aerial()


    local lspsaga = function()
        -- Breadcrumbs and other nice things
        require("lspsaga").setup {
            -- By default, there's a lightbulb for each line there are code actions
            -- for. Unfortunately, this overloads LSPs when scrolling fast.
            lightbulb = { enable = false },
        }
    end
    lspsaga()


    local early_retirement = function()
        -- Close buffers after some time
        require("early-retirement").setup {
            -- Default: 20 min.
            retirementAgeMins = 5,
        }
    end
    early_retirement()

    local neo_tree = function()
        -- Project File Tree
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
    end
    neo_tree()

    local gitsigns = function()
        -- Git goodies
        require("gitsigns").setup {}
    end
    gitsigns()


    local todo_comments = function()
        -- Highlight TODOs
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
    end
    todo_comments()

    local illuminate = function()
        -- Highlight symbol under cursor
        require("illuminate").configure {}
    end
    illuminate()

    local tiny_glimmer = function()
        -- Show animations when yanking
        require("tiny-glimmer").setup {}
    end
    tiny_glimmer()

    local hop = function()
        -- Jumps based on 2 letter prefix
        require("hop").setup {}
    end
    hop()

    local trim = function()
        require("trim").setup {
            trim_on_write = false,
            highlight = true,
        }
    end
    trim()

    local notes = function()
        require("aj.vapor").setup {
            scratch_dir = "~/Documents/notes-synced/daily",
            todo_dir = "~/Documents/notes-synced/todo",
        }
    end
    notes()

    ------------------------------
    -- Filetype-specific config --
    ------------------------------

    local markdown = function()
        -- Markdown --
        --------------
        vim.g.markdown_folding = true

        require("easytables").setup {}

        require("mdeval").setup {
            require_confirmation = false,
        }
    end
    markdown()

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
    end
    yaml()

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


M.setup = function()
    setup_all()
end

return M
