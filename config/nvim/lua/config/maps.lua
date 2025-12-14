local M = {}


M.setup = function()
    local telescope = function() return require("telescope.builtin") end

    local map = function(mode, key, cmd, opts, doc)
        local opts2 = vim.tbl_extend("force", opts, { desc = doc })
        vim.keymap.set(mode, key, cmd, opts2)
    end

    local wk_group = function(key, doc)
        -- In the past I used this fn to document mapping groups. I'm not using which-key anymore, but I'm keeping this
        -- for some time, because I might figure out an alternative way to document these things.
        -- wk.add({ { key, group = doc } })
    end

    local bufmap = vim.api.nvim_buf_set_keymap
    local noremap = { noremap = true }

    -- Buffers
    ------------
    wk_group("<leader>b", "buffer...")
    map("n", "<leader>bb", function() telescope().buffers() end, noremap, "buffers")
    map("n", "<leader>bp", ":bprev<cr>", noremap)
    map("n", "<leader>bn", ":bnext<cr>", noremap)
    map("n", "<leader>bd", ":bp|bd #<cr>", noremap) -- close a buffer, but not a window
    map("n", "<leader>bD", ":%bd|e#|bd#<cr>", noremap)
    map("n", "<leader><TAB>", "<C-^>", noremap)     -- switch to last buffer
    map("n", "<C-PageUp>", ":bprev<cr>", noremap)   -- linux-like prev tab
    map("n", "<C-PageDown>", ":bnext<cr>", noremap) -- linux-like next tab

    map("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory", noremap = true })

    -- Project Sidebar
    ------------------
    local project_finder_opts = {
        -- `find_command` needs to return a list of filenames for fuzzy match on. Telescope defaults to an rg invocation
        -- that ignores hidden and git-ignored files. Instead, I'll use `fd`. It has similar defaults as `rg`, but it's
        -- easier to customize. Opts:
        -- * `--hidden`: include hidden files.
        -- * `--exclude FOO`: don't search inside FOO.
        --
        -- I don't want to include ignored files. That's what find_files is for.
        --
        -- Default call: https://github.com/nvim-telescope/telescope.nvim/blob/b923665e64380e97294af09117e50266c20c71c7/lua/telescope/builtin/__files.lua#L184
        find_command = function()
            return { "sh", "-c", "fd --hidden --exclude .git | proximity-sort " .. vim.fn.expand('%:.') }
        end,
        sorter = require('telescope.sorters').fuzzy_with_index_bias({}),
    }
    wk_group("<leader>p", "project...")
    map("n", "<leader>pb", ":Neotree buffers<CR>", noremap) -- show buffers in the sidebar
    map("n", "<leader>po", ":Neotree reveal<CR>", noremap)  -- show current file in the project tree
    map("n", "<leader>pt", ":Neotree toggle<CR>", noremap)  -- open/close project tree
    map("n", "<leader>pf", function() telescope().find_files(project_finder_opts) end, noremap, "find file by name")


    -- Search
    -----------
    wk_group("<leader>s", "search...")
    map("n", "<leader>sb", function() telescope().current_buffer_fuzzy_find() end, noremap, "search in buffer")
    map("n", "<leader>ss", function() telescope().live_grep() end, noremap, "search in PWD")
    map("n", "<leader>sp", function() require("spectre").toggle() end, noremap, "search in project")
    map({ "n", "v" }, "<leader>sw", function() require("spectre").open_visual() end, noremap, "search selection")
    map({ "n", "v" }, "<leader>sf", function() require("spectre").open_file_search({ select_word = true }) end, noremap,
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
        -- I want this to be relatively open. I have <leader>pf for project-scoped files.
        --
        -- Default call: https://github.com/nvim-telescope/telescope.nvim/blob/b923665e64380e97294af09117e50266c20c71c7/lua/telescope/builtin/__files.lua#L184
        find_command = function()
            return { "sh", "-c", "fd --hidden --no-ignore | proximity-sort " .. vim.fn.expand('%:.') }
        end,
        sorter = require('telescope.sorters').fuzzy_with_index_bias({}),
    }

    wk_group("<leader>f", "files...")
    map("n", "<leader>fr", function() telescope().oldfiles({ only_cwd = true }) end, noremap, "recent files in cwd")
    map("n", "<leader>ff", function() telescope().find_files(all_files_opts) end, noremap, "find all files")
    map("n", "<leader>fy", function() yank_file_path() end, noremap, "copy file path")
    map("n", "<leader>fo", function() open_enclosing_dir_in_finder() end, noremap, "open dir in finder")


    -- Toggles
    -------------
    wk_group("<leader>t", "toggles...")
    map("n", "<leader>ta", ":AerialToggle!<CR>", noremap, "aerial sidebar")
    map("n", "<leader>tn", ":set number!<CR>", noremap, "relative numbers")
    map("n", "<leader>tc", function() require("treesitter-context").toggle() end, noremap, "context bar")
    map("n", "<leader>tz", function() require("zen-mode").toggle() end, noremap, "Zen Mode")

    -- Treesitter Text Objects
    -------------

    -- Selecting
    local ts_sel = function() return require("nvim-treesitter-textobjects.select") end
    local sel_modes = { "x", "o" }

    -- Class
    map(sel_modes, "ik", function() ts_sel().select_textobject("@class.inner", "textobjects") end, noremap)
    map(sel_modes, "ak", function() ts_sel().select_textobject("@class.outer", "textobjects") end, noremap)

    -- Function
    map(sel_modes, "if", function() ts_sel().select_textobject("@function.inner", "textobjects") end, noremap)
    map(sel_modes, "af", function() ts_sel().select_textobject("@function.outer", "textobjects") end, noremap)

    -- Parameter
    -- 'p' is a built-in for 'paragraph'. Overriding it caused timing issues.
    map(sel_modes, "iP", function() ts_sel().select_textobject("@parameter.inner", "textobjects") end, noremap)
    map(sel_modes, "aP", function() ts_sel().select_textobject("@parameter.outer", "textobjects") end, noremap)

    -- Call
    map(sel_modes, "ii", function() ts_sel().select_textobject("@call.inner", "textobjects") end, noremap)
    map(sel_modes, "ai", function() ts_sel().select_textobject("@call.outer", "textobjects") end, noremap)

    -- Moving
    local ts_move = function() return require("nvim-treesitter-textobjects.move") end
    local move_modes = { "n" }

    -- Class
    map(move_modes, "[k", function() ts_move().goto_previous_start("@class.outer", "textobjects") end, noremap)
    map(move_modes, "]k", function() ts_move().goto_next_start("@class.outer", "textobjects") end, noremap)
    map(move_modes, "[K", function() ts_move().goto_previous_end("@class.outer", "textobjects") end, noremap)
    map(move_modes, "]K", function() ts_move().goto_next_end("@class.outer", "textobjects") end, noremap)

    -- Function
    map(move_modes, "[f", function() ts_move().goto_previous_start("@function.outer", "textobjects") end, noremap)
    map(move_modes, "]f", function() ts_move().goto_next_start("@function.outer", "textobjects") end, noremap)
    map(move_modes, "[F", function() ts_move().goto_previous_end("@function.outer", "textobjects") end, noremap)
    map(move_modes, "]F", function() ts_move().goto_next_end("@function.outer", "textobjects") end, noremap)

    -- Parameter
    map(move_modes, "[p", function() ts_move().goto_previous_start("@parameter.inner", "textobjects") end, noremap)
    map(move_modes, "]p", function() ts_move().goto_next_start("@parameter.inner", "textobjects") end, noremap)
    map(move_modes, "[P", function() ts_move().goto_previous_end("@parameter.outer", "textobjects") end, noremap)
    map(move_modes, "]P", function() ts_move().goto_next_end("@parameter.outer", "textobjects") end, noremap)

    -- Call
    map(move_modes, "[i", function() ts_move().goto_previous_start("@call.outer", "textobjects") end, noremap)
    map(move_modes, "]i", function() ts_move().goto_next_start("@call.outer", "textobjects") end, noremap)
    map(move_modes, "[I", function() ts_move().goto_previous_end("@call.outer", "textobjects") end, noremap)
    map(move_modes, "]I", function() ts_move().goto_next_end("@call.outer", "textobjects") end, noremap)

    -- Swapping parameters
    local ts_sw = function() return require("nvim-treesitter-textobjects.swap") end
    local sw_modes = { "n" }
    map(sw_modes, "<C-.>", function() ts_sw().swap_next "@parameter.inner" end, noremap, "Shift parameter left")
    map(sw_modes, "<C-,>", function() ts_sw().swap_previous "@parameter.inner" end, noremap, "Shift parameter right")


    -- Tabs
    -------------
    wk_group("<leader>T", "tabs...")
    map("n", "<leader>Tn", ":tabNext<CR>", noremap)
    map("n", "<leader>Tp", ":tabprev<CR>", noremap)
    map("n", "<leader>TN", ":tabnew<CR>", noremap)
    map("n", "<leader>Td", ":tabclose<CR>", noremap)


    -- Git --
    ---------
    wk_group("<leader>g", "git...")

    local mg = function() return require("mini.git") end

    -- This is awesome! Works with:
    -- * Normal files. Shows git log touching the lines.
    -- * Commit SHAs. Shows individual commit details.
    -- * Diff inside commit. Shows the full file. Before or after depending on the '-' or '+' line being under the cursor.
    map({"n", "v"}, "<leader>gi", function() mg().show_at_cursor() end, noremap, "inspect at cursor")

    -- Telescope and git
    map("n", "<leader>gs", function() telescope().git_status() end, noremap, "git status")

    -- openingh
    map("n", "<Leader>gr", ":OpenInGHRepo <CR>", noremap)
    map("n", "<Leader>gf", ":OpenInGHFile <CR>", noremap)
    map({"n", "v"}, "<Leader>gl", ":OpenInGHFileLines <CR>", noremap)

    -- Git conflicts
    local function find_git_conflicts()
        local conflicts = {}
        local handle = io.popen("git diff --name-only --diff-filter=U 2>/dev/null")
        if not handle then return end

        for filename in handle:lines() do
            if filename and filename ~= "" then
                local file_handle = io.open(filename, "r")
                if file_handle then
                    local line_num = 0
                    local conflict_start = nil

                    for line in file_handle:lines() do
                        line_num = line_num + 1

                        if line:match("^<<<<<<<") then
                            conflict_start = line_num
                        elseif line:match("^=======") and conflict_start then
                            -- Found the middle of a conflict
                        elseif line:match("^>>>>>>>") and conflict_start then
                            -- Found the end of a conflict, add to quickfix
                            table.insert(conflicts, {
                                filename = filename,
                                lnum = conflict_start,
                                col = 1,
                                text = "Git conflict (lines " .. conflict_start .. "-" .. line_num .. ") in " .. filename
                            })
                            conflict_start = nil
                        end
                    end
                    file_handle:close()
                end
            end
        end
        handle:close()

        if #conflicts > 0 then
            vim.fn.setqflist(conflicts, "r")
            vim.cmd("copen")
            print("Found " .. #conflicts .. " conflict section(s)")
        else
            print("No git conflicts found")
        end
    end

    map("n", "<leader>gc", find_git_conflicts, noremap, "find git conflicts")

    -- toggles
    wk_group("<leader>tg", "git toggles...")

    -- Root
    ---------

    -- Diagnostics
    wk_group("<leader>td", "diagnostic toggles...")
    map("n", "<leader>tdl", function()
        vim.diagnostic.config({ virtual_lines = not vim.diagnostic.config().virtual_lines })
    end, noremap, "Toggle diagnostics as lines")

    map("n", "<leader>tdt", function()
        vim.diagnostic.config({ virtual_text = not vim.diagnostic.config().virtual_text })
    end, noremap, "Toggle diagnostics as text")

    -- Similar to LSP's <C-K> for hover float.
    map("n", "<C-K>", function() vim.diagnostic.open_float() end, noremap, "Open diagnostics float")


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
    map("n", "<localleader>Li", ":checkhealth vim.lsp<CR>", noremap, "LSP client info")
    map("n", "<localleader>Ld", ":lua vim.lsp.stop_client(vim.lsp.get_active_clients())<CR>", noremap, "Kill all clients attached to this buf")

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
    local iron = function() return require("iron.core") end
    map("n", "<localleader>rr", ":IronRepl<CR>", noremap, "Toggle iron repl")
    map("n", "<localleader>rR", ":IronRestart<CR>", noremap, "Restart iron repl")
    map("n", "<localleader>re", function() iron().send_line() end, noremap, "Eval line")
    map("v", "<localleader>re", function()
        iron().mark_visual()
        iron().send_mark()
    end, noremap, "Eval visual")
    map("n", "<localleader>rgg", function() iron().send_until_cursor() end, noremap, "Eval from beginning of file until cursor")


    -- Rebinds
    ----------
    -- Rebind § to ` for compatibility with Linux.
    vim.api.nvim_set_keymap("i", "§", "`", noremap)

    -- Global
    ----------
    map({ "n", "v" }, "<leader><leader>", function() telescope().commands() end, noremap, "commands")
    map("v", "*", '"sy:lua vim.api.nvim_command("/" .. vim.fn.getreg("s"))<CR>', noremap) -- search for selected text
    map("n", "yp", '"0p', noremap, "paste last yanked")
    map("n", "yP", '"0P', noremap, "paste last yanked, prev")

    map("n", "s/", ":HopPatternMW<CR>", noremap)
    map("n", "ss", ":HopChar2MW<CR>", noremap)
    map("n", "ss", ":HopChar2MW<CR>", noremap)

    map("n", "<leader>?", function() telescope().keymaps() end, noremap, "keymaps")

    -- Enable standard terminal keybindings in the vim command mode
    local readline = function() return require("readline") end
    vim.keymap.set({"c"}, '<M-f>', function() readline().forward_word() end)
    vim.keymap.set({"c"}, '<M-b>', function() readline().backward_word() end)
    vim.keymap.set({"c"}, '<C-a>', function() readline().beginning_of_line() end)
    vim.keymap.set({"c"}, '<C-e>', function() readline().end_of_line() end)
    vim.keymap.set({"c"}, '<M-d>', function() readline().kill_word() end)
    vim.keymap.set({"c"}, '<M-BS>', function() readline().backward_kill_word() end)
    vim.keymap.set({"c"}, '<C-w>', function() readline().unix_word_rubout() end)
    vim.keymap.set({"c"}, '<C-k>', function() readline().kill_line() end)
    vim.keymap.set({"c"}, '<C-u>', function() readline().backward_kill_line() end)

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
