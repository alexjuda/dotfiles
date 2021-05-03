--------
-- UI --
--------

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
vim.o.shiftwidth = 4
vim.o.expandtab = true

-- Ask for confirmation instead of failing by default
vim.o.confirm = true

-- Show at least one more line when scrolling
vim.o.scrolloff = 1

-- Highlight line under cursor
vim.o.cursorline = true

-- Show line numbers
vim.o.number = true

-- Add some left margin
vim.o.numberwidth = 6

-- Enable scrolling with mouse
vim.o.mouse = "a"

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

local lsp_on_attach = function(client, buf_n)
    -- We use competion-nvim autocompletion popup instead of the built-in omnifunc
    -- `<Plug>` commands need recursive mapping.
    vim.api.nvim_buf_set_keymap(buf_n, "i", "<C-Space>", "<Plug>(completion_trigger)", { noremap=false })

    -- Keymap
    local opts = { noremap=true }
    vim.api.nvim_buf_set_keymap(buf_n, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
    vim.api.nvim_buf_set_keymap(buf_n, "n", "<localleader>ld", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
    vim.api.nvim_buf_set_keymap(buf_n, "n", "<localleader>lD", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
    vim.api.nvim_buf_set_keymap(buf_n, "n", "<localleader>li", ":LspInfo<cr>", opts)
    vim.api.nvim_buf_set_keymap(buf_n, "n", "<localleader>lr", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)

    -- Set keymap only if language server supports it. This way which-key window will show only supported stuff.
    if client.resolved_capabilities.document_formatting then
        vim.api.nvim_buf_set_keymap(buf_n, "n", "<localleader>lf", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
    end
    if client.resolved_capabilities.document_range_formatting then
        vim.api.nvim_buf_set_keymap(buf_n, "v", "<localleader>lf", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
    end
end

-- Python
require("lspconfig").pyls.setup {
    settings = {
        pyls = {
            configurationSources = {"flake8"},
        },
    },
    on_attach = lsp_on_attach,
}
