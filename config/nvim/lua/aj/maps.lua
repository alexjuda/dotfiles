local M = {}


M.setup = function()
    local wk = require("which-key")
    local telescope = require("telescope.builtin")
    local vapor = require("aj.vapor")
    local spectre = require("spectre")

    local map = function(mode, key, cmd, opts, doc)
        vim.keymap.set(mode, key, cmd, opts)

        if doc then
            wk.add({ { key, desc = doc } })
        end
    end

    local wk_group = function(key, doc)
        wk.add({ { key, group = doc } })
    end

    local bufmap = vim.api.nvim_buf_set_keymap
    local noremap = { noremap = true }


    -- Leaders
    ------------
    vim.g.mapleader = " "      -- space as the leader key
    vim.g.maplocalleader = "," -- comma as the local leader key


    -- Buffers
    ------------
    wk_group("<leader>b", "buffer...")
    map("n", "<leader>bb", function() telescope.buffers() end, noremap, "buffers")
    map("n", "<leader>bp", ":bprev<cr>", noremap)
    map("n", "<leader>bn", ":bnext<cr>", noremap)
    map("n", "<leader>bd", ":bp|bd #<cr>", noremap) -- close a buffer, but not a window
    map("n", "<leader>bD", ":%bd|e#|bd#<cr>", noremap)
    map("n", "<leader><TAB>", "<C-^>", noremap)     -- switch to last buffer
    map("n", "<C-PageUp>", ":bprev<cr>", noremap)   -- linux-like prev tab
    map("n", "<C-PageDown>", ":bnext<cr>", noremap) -- linux-like next tab


    -- Project Sidebar
    ------------------
    local project_finder_opts = {
        -- `find_command` needs to return a list of filenames for fuzzy match on. Telescope defaults to an rg invocation
        -- that ignores hidden and git-ignored files. Instead, I'll use `fd`. It has similar defaults as `rg`, but it's
        -- easier to customize. Opts:
        -- * `--hidden`: include hidden files.
        -- * `--no-ignore`: include git-ignored files.
        -- * `--exclude FOO`: don't search inside FOO.
        --
        -- Default call: https://github.com/nvim-telescope/telescope.nvim/blob/b923665e64380e97294af09117e50266c20c71c7/lua/telescope/builtin/__files.lua#L184
        find_command = {
            "fd",
            "--hidden",
            "--no-ignore",
            "--exclude", ".git",
            "--exclude", ".node_modules",
            "--exclude", ".venv",
        },
    }
    wk_group("<leader>p", "project...")
    map("n", "<leader>pb", ":Neotree buffers<CR>", noremap) -- show buffers in the sidebar
    map("n", "<leader>po", ":Neotree reveal<CR>", noremap)  -- show current file in the project tree
    map("n", "<leader>pt", ":Neotree toggle<CR>", noremap)  -- open/close project tree
    map("n", "<leader>pf", function() telescope.find_files(project_finder_opts) end, noremap, "find file by name")


    -- Search
    -----------
    wk_group("<leader>s", "search...")
    map("n", "<leader>sb", function() telescope.current_buffer_fuzzy_find() end, noremap, "search in buffer")
    map("n", "<leader>ss", function() telescope.live_grep() end, noremap, "search in PWD")
    map("n", "<leader>sp", function() spectre.toggle() end, noremap, "search in project")
    map({ "n", "v" }, "<leader>sw", function() spectre.open_visual() end, noremap, "search selection")
    map({ "n", "v" }, "<leader>sf", function() spectre.open_file_search({ select_word = true }) end, noremap,
        "search in current file")


    -- Files
    ----------
    local yank_file_path = function()
        -- Get current buffer's file path relative to PWD.
        -- Yank it to the system clipboard.
        -- Src: https://stackoverflow.com/a/954336
        vim.cmd([[
        let @+ = expand("%:.")
    ]])
    end

    local open_enclosing_dir_in_finder = function()
        -- Filename modifiers used:
        -- * "%" - current buffer
        -- * ":p" - full absolute path
        -- * ":h" - skip one level
        local dir_path = vim.fn.expand('%:p:h')
        os.execute("xdg-open " .. dir_path)
    end

    local all_files_opts = {
        -- `find_command` needs to return a list of filenames for fuzzy match on. Telescope defaults to an rg invocation
        -- that ignores hidden and git-ignored files. Instead, I'll use `fd`. It has similar defaults as `rg`, but it's
        -- easier to customize. Opts:
        -- * `--hidden`: include hidden files.
        -- * `--no-ignore`: include git-ignored files.
        --
        -- Default call: https://github.com/nvim-telescope/telescope.nvim/blob/b923665e64380e97294af09117e50266c20c71c7/lua/telescope/builtin/__files.lua#L184
        find_command = {
            "fd",
            "--hidden",
            "--no-ignore",
        },
    }

    wk_group("<leader>f", "files...")
    map("n", "<leader>fr", function() telescope.oldfiles({ only_cwd = true }) end, noremap, "recent files in cwd")
    map("n", "<leader>ff", function() telescope.find_files(all_files_opts) end, noremap, "find all files")
    map("n", "<leader>fy", function() yank_file_path() end, noremap, "copy file path")
    map("n", "<leader>fo", function() open_enclosing_dir_in_finder() end, noremap, "open dir in finder")


    -- Toggles
    -------------
    wk_group("<leader>t", "toggles...")
    map("n", "<leader>tn", ":set number!<CR>", noremap)
    map("n", "<leader>ta", ":AerialToggle!<CR>", noremap) -- Toggle aerial sidebar


    -- Tabs
    -------------
    wk_group("<leader>T", "tabs...")
    map("n", "<leader>Tn", ":tabNext<CR>", noremap)
    map("n", "<leader>Tp", ":tabprev<CR>", noremap)
    map("n", "<leader>TN", ":tabnew<CR>", noremap)
    map("n", "<leader>Td", ":tabclose<CR>", noremap)


    -- Notes
    ----------
    -- TODO: delete vapor :(
    map("n", "<leader>nd", function() vapor.open_scratch() end, noremap, "daily note")
    map("n", "<leader>nt", function() vapor.open_todo() end, noremap, "daily todo")


    -- Git
    --------
    wk_group("<leader>c", "choose...")
    map("n", "<leader>co", "<Plug>(git-conflict-ours)", noremap, "choose ours")
    map("n", "<leader>ct", "<Plug>(git-conflict-theirs)", noremap, "choose theirs")
    map("n", "<leader>cb", "<Plug>(git-conflict-both)", noremap, "choose both")
    map("n", "<leader>c0", "<Plug>(git-conflict-none)", noremap, "choose none")
    map("n", "[x", "<Plug>(git-conflict-prev-conflict)", noremap, "prev conflict")
    map("n", "]x", "<Plug>(git-conflict-next-conflict)", noremap, "next conflict")

    -- Gitsigns
    -- src: https://github.com/lewis6991/gitsigns.nvim#keymaps
    ----------------------------------------------------------
    local gs = require("gitsigns")

    -- GitSigns
    wk_group("<leader>g", "git...")
    map('n', '<leader>gp', function() gs.preview_hunk() end, noremap, "preview hunk")
    map('n', '<leader>gd', function() gs.diffthis() end, noremap, "show current unstaged diff")

    wk_group("<leader>tg", "git toggles...")
    map('n', '<leader>tgb', function() gs.toggle_current_line_blame() end, noremap, "toggle current line blame")
    map('n', '<leader>tgd', function() gs.preview_hunk_inline() end, noremap, "preview diff hunk")

    -- Navigation
    map('n', ']g', function()
        if vim.wo.diff then return ']c' end
        vim.schedule(function() gs.nav_hunk("next") end)
        return '<Ignore>'
    end, { expr = true })

    map('n', '[g', function()
        if vim.wo.diff then return '[c' end
        vim.schedule(function() gs.nav_hunk("prev") end)
        return '<Ignore>'
    end, { expr = true })

    -- Telescope and git
    map("n", "<leader>gs", function() telescope.git_status() end, noremap, "git status")
    map("n", "<leader>gS", function() telescope.git_stash() end, noremap, "git stash")

    -- openingh
    map("n", "<Leader>gr", ":OpenInGHRepo <CR>", noremap)
    map("n", "<Leader>gf", ":OpenInGHFile <CR>", noremap)
    map("n", "<Leader>gl", ":OpenInGHFileLines <CR>", noremap)

    -- Root
    ---------
    map("n", "<leader><esc>", ":nohlsearch<cr>", noremap)

    -- Diagnostics
    wk_group("<leader>td", "diagnostic toggles...")
    map("n", "<leader>tdl", function()
        vim.diagnostic.config({ virtual_lines = not vim.diagnostic.config().virtual_lines })
    end, noremap, "Toggle diagnostics as lines")

    map("n", "<leader>tdt", function()
        vim.diagnostic.config({ virtual_text = not vim.diagnostic.config().virtual_text })
    end, noremap, "Toggle diagnostics as text")


    -- Local leader
    -----------------

    -- venn --
    -- enable or disable keymappings for venn
    local function toggle_venn()
        local venn_enabled = vim.inspect(vim.b.venn_enabled)
        if (venn_enabled == "nil") then
            vim.b.venn_enabled = true
            vim.cmd [[setlocal ve=all]]
            -- draw a line on HJKL keystokes
            bufmap(0, "n", "J", "<C-v>j:VBox<cr>", noremap)
            bufmap(0, "n", "K", "<C-v>k:VBox<cr>", noremap)
            bufmap(0, "n", "L", "<C-v>l:VBox<cr>", noremap)
            bufmap(0, "n", "H", "<C-v>h:VBox<cr>", noremap)
            -- draw a box by pressing "f" with visual selection
            bufmap(0, "v", "f", ":VBox<cr>", noremap)
            -- when on a symbol, draw a box around the symbol
            bufmap(0, "n", "<localleader>f", "Bkh<C-V>jEjl:VBox<cr>", noremap)
        else
            vim.cmd [[setlocal ve=]]
            vim.cmd [[mapclear <buffer>]]
            vim.b.venn_enabled = nil
        end
    end

    map("n", "<leader>tv", function() toggle_venn() end, noremap, "toggle venn")

    -- Show info about currently active LSP connections
    wk_group("<leader>L", "LSP connections...")
    -- TODO: use map()
    vim.api.nvim_set_keymap("n", "<localleader>Li", ":LspInfo<CR>", noremap)

    -- Kill LSP clients
    vim.api.nvim_set_keymap("n", "<localleader>Ld", ":lua vim.lsp.stop_client(vim.lsp.get_active_clients())<CR>", noremap)

    -- Evaluating markdown code blocks --
    vim.api.nvim_set_keymap("n", "<localleader>ee", ":MdEval<CR>", noremap)
    vim.api.nvim_set_keymap("n", "<localleader>ed", ":MdEvalClean<CR>", noremap)

    -- Running tests with neotest
    wk_group("<localleader>t", "tests...")
    map("n", "<localleader>tt", function() require("neotest").run.run() end, noremap, "Run nearest test")
    map("n", "<localleader>ts", function() require("neotest").run.stop() end, noremap, "Stop nearest test")
    map("n", "<localleader>ta", function() require("neotest").run.attach() end, noremap, "Attach to nearest test")

    -- iron.nvim
    wk_group("<localleader>r", "repl...")
    local iron = require("iron.core")
    map("n", "<localleader>rr", ":IronRepl<CR>", noremap, "Toggle iron repl")
    map("n", "<localleader>rR", ":IronRestart<CR>", noremap, "Restart iron repl")
    map("n", "<localleader>re", function() iron.send_line() end, noremap, "Eval line")
    map("v", "<localleader>re", function()
        iron.mark_visual()
        iron.send_mark()
    end, noremap, "Eval visual")
    map("n", "<localleader>rgg", function() iron.send_until_cursor() end, noremap, "Eval from beginning of file until cursor")


    -- Rebinds
    ----------
    -- Rebind § to ` for compatibility with Linux.
    vim.api.nvim_set_keymap("i", "§", "`", noremap)

    -- Global
    ----------
    map({ "n", "v" }, "<leader><leader>", function() telescope.commands() end, noremap, "commands")
    map("v", "*", '"sy:lua vim.api.nvim_command("/" .. vim.fn.getreg("s"))<CR>', noremap) -- search for selected text
    map("n", "yp", '"0p', noremap, "paste last yanked")
    map("n", "yP", '"0P', noremap, "paste last yanked, prev")

    map("n", "s/", ":HopPatternMW<CR>", noremap)
    map("n", "ss", ":HopChar2MW<CR>", noremap)
    map("n", "ss", ":HopChar2MW<CR>", noremap)

    -- Enable standard terminal keybindings in the vim command mode
    local readline = require 'readline'
    vim.keymap.set('!', '<M-f>', readline.forward_word)
    vim.keymap.set('!', '<M-b>', readline.backward_word)
    vim.keymap.set('!', '<C-a>', readline.beginning_of_line)
    vim.keymap.set('!', '<C-e>', readline.end_of_line)
    vim.keymap.set('!', '<M-d>', readline.kill_word)
    vim.keymap.set('!', '<M-BS>', readline.backward_kill_word)
    vim.keymap.set('!', '<C-w>', readline.unix_word_rubout)
    vim.keymap.set('!', '<C-k>', readline.kill_line)
    vim.keymap.set('!', '<C-u>', readline.backward_kill_line)

    -- Don't override yank buffer on delete. Instead, put it in the named buffer 'a'.
    -- Source: https://www.reddit.com/r/neovim/comments/154s3x0/comment/jsr7aei/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
    vim.keymap.set({ 'n', 'v' }, 'x', '"ax', { noremap = true })
    vim.keymap.set({ 'n', 'v' }, 'd', '"ad', { noremap = true })
    vim.keymap.set({ 'n', 'v' }, 'c', '"ac', { noremap = true })
    vim.keymap.set('n', 'D', '"aD', { noremap = true })
    vim.keymap.set('n', 'C', '"aC', { noremap = true })


    ------------------
    -- My own utils --
    ------------------

    -- Inserting values at point --
    --------------------------------
    --
    local function insert_text_at_cursor(text)
        -- Based on https://vi.stackexchange.com/a/39684
        local current_win = 0
        local row, col = unpack(vim.api.nvim_win_get_cursor(current_win))
        local text_len = text:len()

        vim.api.nvim_buf_set_text(0, row - 1, col, row - 1, col, { text })
        vim.api.nvim_win_set_cursor(current_win, { row, col + text_len })
    end

    -- Insert current date anywhere
    local function local_date(timestamp)
        return os.date("%Y-%m-%d", timestamp)
    end

    local function insert_current_date()
        local date = local_date(os.time())
        insert_text_at_cursor(date)
    end

    vim.keymap.set({ "i", "n" }, "<F3>", insert_current_date)

    -- Insert webpage title when pasting into markdown
    -- Source: https://www.reddit.com/r/vim/comments/139fn2b/comment/js7mth4/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button

    local InsertMarkdownURL = function()
        local url = vim.fn.getreg "+"
        if url == "" then return end
        local cmd = "curl -L " .. vim.fn.shellescape(url) .. " 2>/dev/null"
        local handle = io.popen(cmd)
        if not handle then return end
        local html = handle:read "*a"
        handle:close()
        local title = ""
        local pattern = "<title>(.-)</title>"
        local m = string.match(html, pattern)
        if m then title = m end
        if title ~= "" then
            local markdownLink = "[" .. title .. "](" .. url .. ")"
            vim.api.nvim_command("call append(line('.'), '" .. markdownLink .. "')")
        else
            print("Title not found for link")
        end
    end

    wk_group("<leader>m", "markdown...")
    vim.keymap.set("n", "<leader>mdp", function() InsertMarkdownURL() end, { silent = true, noremap = true })
end


return M
