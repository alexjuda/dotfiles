--------
-- UI --
--------

-- Buffer- or window-local options that we want to provide deafults for need
-- to be set both globally and "locally". 
-- See https://oroques.dev/notes/neovim-init/#set-options

-- Improve scrolling performance, especially in tmux
vim.o.lazyredraw = true

-- Make splits happen at the other part of the screen
vim.o.splitbelow = true
vim.o.splitright = true

-- Use point system clipboard to the default register
vim.o.clipboard = "unnamed"

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
vim.o.scrolloff = 1
vim.wo.scrolloff = 1

-- Highlight line under cursor
vim.o.cursorline = true
vim.wo.cursorline = true

-- Show line numbers
vim.o.number = true
vim.wo.number = true

-- Add some left margin
vim.o.numberwidth = 6
vim.wo.numberwidth = 6

-- Enable scrolling with mouse
vim.o.mouse = "a"

-- Improve experience with nvim-completion
vim.o.completeopt = "menuone,noinsert,noselect"


------------
-- Colors --
------------

require("colorbuddy").colorscheme("onebuddy")

----------------
-- Treesitter --
----------------

-- highlight
require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    -- custom_captures = {
    --   -- Highlight the @foo.bar capture group with the "Identifier" highlight group.
    --   ["foo.bar"] = "Identifier",
    -- },
  },
}

-- incremental selection
require'nvim-treesitter.configs'.setup {
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },
}


-- indentation
require'nvim-treesitter.configs'.setup {
  indent = {
    enable = true
  }
}

-- folding
-- Use treesitter's expressions to form folds
vim.o.foldmethod="expr"
vim.o.foldexpr="nvim_treesitter#foldexpr()"

---------
-- LSP --
---------

-- Buffer-local options + keymap

local set_lsp_keymaps = function(client, buf_n)
    -- We use competion-nvim autocompletion popup instead of the built-in omnifunc
    -- `<Plug>` commands need recursive mapping.
    vim.api.nvim_buf_set_keymap(buf_n, "i", "<C-Space>", "<Plug>(completion_trigger)", { noremap=false })

    -- Keymap
    local opts = { noremap=true }
    vim.api.nvim_buf_set_keymap(buf_n, "n", "K", ":lua vim.lsp.buf.hover()<CR>", opts)
    vim.api.nvim_buf_set_keymap(buf_n, "n", "<localleader>ld", ":lua vim.lsp.buf.definition()<CR>", opts)
    vim.api.nvim_buf_set_keymap(buf_n, "n", "<localleader>lD", ":lua vim.lsp.buf.references()<CR>", opts)
    vim.api.nvim_buf_set_keymap(buf_n, "n", "<localleader>li", ":LspInfo<CR>", opts)
    vim.api.nvim_buf_set_keymap(buf_n, "n", "<localleader>lr", ":lua vim.lsp.buf.rename()<CR>", opts)

    -- Set keymap only if language server supports it. This way which-key window will show only supported stuff.
    if client.resolved_capabilities.document_formatting then
        vim.api.nvim_buf_set_keymap(buf_n, "n", "<localleader>lf", ":lua vim.lsp.buf.formatting()<CR>", opts)
    end
    if client.resolved_capabilities.document_range_formatting then
        vim.api.nvim_buf_set_keymap(buf_n, "v", "<localleader>lf", ":lua vim.lsp.buf.range_formatting()<CR>", opts)
    end
end

local shared_on_attach = function(client, buf_n)
    -- Set up completion-nvim
    require("completion").on_attach(client, buf_n)

    -- TODO: port recommended completion options from
    -- https://github.com/alexjuda/dotfiles/blob/7bb4b1803b9d8ce52c77256cc8477cc6ed45e8f5/.config/nvim/init.vim#L168

    set_lsp_keymaps(client, buf_n)
end

-- Python
require("lspconfig").pyls.setup {
    settings = {
        pyls = {
            configurationSources = {"flake8"},
        },
    },
    on_attach = shared_on_attach,
}


-- Java
-- Assumes that a language server distribution is available in the proper 
-- directory. Fetch it from https://ftp.fau.de/eclipse/jdtls/snapshots/, put 
-- it in ~/.local/share/aj-lsp/ and make a symlink so the paths here work.

local is_mac = function() 
    return vim.fn.has("macunix") == 1
end

require("lspconfig").jdtls.setup {
    cmd = {
        "java",
        "-jar",
        vim.env.HOME .. "/.local/share/aj-lsp/jdtls/plugins/org.eclipse.equinox.launcher_1.6.100.v20201223-0822.jar",
        "-configuration",
        vim.env.HOME .. "/.local/share/aj-lsp/jdtls/" .. (is_mac() and "config_mac" or "config_linux"),
    },

    on_attach = shared_on_attach,
}


-----------
-- Fuzzy --
-----------

-- Allow fuzzy matching in autocomplete popup
-- Tis no work yo :(
-- vim.g.completion_matching_strategy_list = { "exact", "substring", "fuzzy", }

-- setup nvim-lspfuzzy
require("lspfuzzy").setup {}

-----------
-- Notes --
-----------

require("vapor").setup {
    daily_notes_dir = "~/Documents/notes-synced/daily",
    notes_index_file = "~/Documents/notes-synced/README.md",
}
