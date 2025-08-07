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
        -- Catppuccin defaults to "mocha" in dark mode and "latte" in light mode.
        vim.cmd.colorscheme "catppuccin"
        -- vim.cmd.colorscheme "rose-pine"
        -- vim.cmd.colorscheme "nightfox"
    end
    colors()

    local csv_view = function()
        require("csvview").setup {
            view = {
                display_mode = "border",
            },
        }
    end
    csv_view()

    local marks = function()
        require("marks").setup {}
    end
    marks()

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
                "hcl",
                "helm",
                "hjson",
                "html",
                "http",
                "java",
                "javascript",
                "json",
                "latex",
                "lua",
                "make",
                "markdown",
                "markdown_inline",
                "mermaid",
                "python",
                "requirements",
                "rst",
                "sql",
                "terraform",
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

        require("treesitter-context").setup {
            -- Show top context window based on the cropped code block on the
            -- top. Defaults to showing only previews from under cursor.
            mode = "topline",
        }
    end
    treesitter()

    local neotest = function()
        require("neotest").setup {
            adapters = {
                require("neotest-python"),
            }
        }
    end
    neotest()

    local llms = function()
        -- See https://github.com/zbirenbaum/copilot.lua?tab=readme-ov-file#setup-and-configuration for keybindings.
        require('copilot').setup({
            suggestion = {
                auto_trigger = true,
                keymap = {
                    -- Default mappings clash with Aero Space on macOS.
                    accept = "<Tab>",
                },
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

    local lsp_progress = function()
        require("lsp-progress").setup {}
    end
    lsp_progress()

    local status_line = function()
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
                -- The blue bar.
                lualine_a = {
                    {
                        -- Show buffer number using the vim status line format:
                        -- https://vimdoc.sourceforge.net/htmldoc/options.html#'statusline'
                        "%n",
                    },
                },
                -- The gray bar.
                lualine_b = {
                    {
                        -- Show total count of open buffers.
                        function()
                            local loaded = 0
                            for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
                                if vim.api.nvim_buf_is_loaded(bufnr) then
                                    loaded = loaded + 1
                                end
                            end
                            return loaded
                        end,
                    },
                },
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
                    "copilot",
                    "filetype",
                    function()
                        return require("lsp-progress").progress()
                    end,
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
        }
    end
    status_line()

    local aerial = function()
        -- Symbols sidebar
        require("aerial").setup {}
    end
    aerial()

    local early_retirement = function()
        -- Close buffers after some time
        require("early-retirement").setup {
            -- Default: 20 min.
            retirementAgeMins = 5,

            -- Ignore buffers with unsaved changes. If false, the buffers will
            -- automatically be written and then closed.
            ignoreUnsavedChangesBufs = false,

            -- Ignore non-empty buftypes, for example terminal buffers
            ignoreSpecialBuftypes = true,

            -- When a file is deleted, for example via an external program, delete the
            -- associated buffer as well. Requires Neovim >= 0.10.
            -- (This feature is independent from the automatic closing)
            deleteBufferWhenFileDeleted = false,

            -- Need to include the default values as well because the typing in this package causes LSP to complain.
            ignoredFiletypes = {},
            ignoreFilenamePattern = "",
            ignoreAltFile = true,
            minimumBufferNum = 1,
            ignoreVisibleBufs = true,
            ignoreUnloadedBufs = false,
            notificationOnAutoClose = false,
            deleteFunction = vim.nvim_buf_delete,
        }
    end
    early_retirement()

    local neo_tree = function()
        -- Project File Tree
        require("neo-tree").setup {
            filesystem = {
                -- Let dirbuf handle editing directories.
                hijack_netrw_behavior = "disabled",
            },
        }
    end
    neo_tree()

    local oil = function()
        require("oil").setup {
            columns = {
                "icon",
                -- "permissions",
                -- "size",
                -- "mtime",
            },
            -- Workaround for horizontal stuttering when a given level is first rendered.
            win_options = {
                conceallevel = 0,
            },
        }
    end
    oil()

    local gitsigns = function()
        -- Git goodies
        require("gitsigns").setup {}
    end
    gitsigns()

    local diffview = function()
        require("diffview").setup {
            view = {
                merge_tool = {
                    layout = "diff4_mixed",
                }
            }
        }
    end
    diffview()

    local git_conflict = function()
        require("git-conflict").setup {
            default_mappings = false,
        }
    end
    git_conflict()

    local indent_blankline = function()
        require("ibl").setup {}
    end
    indent_blankline()

    local iron = function()
        -- Snippet taken from https://github.com/Vigemus/iron.nvim.
        local iron = require("iron.core")
        local view = require("iron.view")
        local common = require("iron.fts.common")

        iron.setup {
          config = {
            -- Whether a repl should be discarded or not
            scratch_repl = true,
            repl_definition = {
              sh = {
                -- Can be a table or a function that
                -- returns a table (see below)
                command = {"zsh"}
              },
              python = {
                command = { "ipython", "--no-autoindent" },
                format = common.bracketed_paste_python,
                block_deviders = { "# %%", "#%%" },
              }
            },
            -- Display the REPL in a window below.
            repl_open_cmd = view.split.horizontal.botright("25%")

          },
          -- ignore_blank_lines = true, -- ignore blank lines when sending visual select lines
        }
    end
    iron()

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

    local image = function()
        require("image").setup {
            integrations = {
                markdown = {
                    only_render_image_at_cursor = true,     -- defaults to false
                    only_render_image_at_cursor_mode = "popup", -- "popup" or "inline", defaults to "popup"
                }
            },
        }

    end
    image()

    local diagram = function ()
        -- Requires 'mmdc' at PATH: 'npm install -g @mermaid-js/mermaid-cli'.
        require("diagram").setup {
            renderer_options = {
                mermaid = {
                    -- Default scale is 1, but it's way too small for my monitors.
                    scale = 2,
                    -- Default settings work good for light mode, but I use dark mode more.
                    theme = "dark",
                    background = "transparent",
                },
            },
        }
    end
    -- diagram()

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

    ------------------------------
    -- Filetype-specific config --
    ------------------------------

    local markdown = function()
        require("mdeval").setup {
            require_confirmation = false,
        }

        require("render-markdown").setup {
            heading = {
                -- Heandings are too confusing.
                enabled = false,
                -- By default, headings would get a full-line bar.
                -- width = "block",
                -- left_pad = 1,
                -- right_pad = 1,
                -- border = true,
                -- -- Make all the headings symmetric in shape.
                -- position = "inline",
            },
            code = {
                -- Defaults to concealing the bottom ```. Switching between insert and normal modes causes the whole
                -- page to flicker, which is super annoying.
                border = "thin",
            },
            checkbox = {
                -- Show bullet before the checkbox. Improves layout for nested lists.
                bullet = true,
                unchecked = {
                    -- Add space prefix to stabilize the layout.
                    icon = " 󰄱 ",
                },
                checked = {
                    -- Add space prefix to stabilize the layout.
                    icon = ' 󰱒 ',
                },
            },
            link = {
                -- Disable showing icons in front of URLs.
                enabled = false,
            },
            win_options = {
                conceallevel = {
                    -- Hide backticks, links, and fenced blocks in markdown (level > 0). On the other hand, don't change the horizontal
                    -- placement of letters (level < 2).
                    rendered = 1,
                }
            },
        }
    end
    markdown()
end


M.setup = function()
    setup_all()
end

return M
