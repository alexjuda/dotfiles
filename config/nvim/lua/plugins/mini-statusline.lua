-- Filename: relative path + modified symbol (matches your lualine `path = 1` & symbols)
local function get_filename()
    local name = vim.fn.expand("%:.") or ""
    if name == "" then name = "[No Name]" end
    if vim.bo.modified then name = name .. " ●" end
    return name
end


local function get_position_info()
    -- Equivalent to vi’s default statusline info: "65% 120,4"
    local pos = vim.api.nvim_eval_statusline("%p%% %l,%c", {}).str
    -- We have to escape percent because it's a special char in mini.statusline syntax.
    return pos:gsub("%%", "%%%%")
end


-- Show selection info in Visual mode: "5C 2W 3L"
local function get_visual_selection_info()
    local mode = vim.fn.mode()
    if not mode:match("[vV\x16]") then return "" end  -- only in visual mode

    local start_pos = vim.fn.getpos("v")
    local end_pos = vim.fn.getpos(".")
    local start_line, start_col = start_pos[2], start_pos[3]
    local end_line, end_col = end_pos[2], end_pos[3]

    if start_line > end_line or (start_line == end_line and start_col > end_col) then
        start_line, end_line = end_line, start_line
        start_col, end_col = end_col, start_col
    end

    local lines = vim.fn.getline(start_line, end_line)
    if #lines == 0 then return "" end

    -- Compute char count
    local chars
    if #lines == 1 then
        chars = end_col - start_col + 1
    else
        chars = (#lines[1] - start_col + 1) + end_col
        for i = 2, #lines - 1 do
            chars = chars + #lines[i]
        end
    end

    -- TODO: fix word counter
    -- Compute word count
    -- local text = table.concat(lines, "\n")
    -- local words = vim.fn.split(text, [[\W\+]])
    -- local word_count = #vim.tbl_filter(function(w) return w ~= "" end, words)

    return string.format("%dC %dL", chars, #lines)
end

return {
    "echasnovski/mini.statusline",
    version = false,
    event = "VeryLazy",
    config = function()
        -- require module and keep reference for helper functions
        local MS = require("mini.statusline")

        MS.setup({
            use_icons = true,
            -- Provide active/inactive content functions
            content = {
                active = function()
                    -- honor disabled ft
                    if vim.bo.filetype == "neo-tree" then return "" end

                    -- built-in helpers (truncate widths are adjustable)
                    local _, mode_hl = MS.section_mode({ trunc_width = 120 })
                    local diagnostics = MS.section_diagnostics({ trunc_width = 75 })
                    local search = MS.section_searchcount({ trunc_width = 75 })
                    local lsp = MS.section_lsp and MS.section_lsp({ trunc_width = 75 }) or ""

                    -- custom bits
                    local bufnum = tostring(vim.fn.bufnr("%"))
                    local bufcount = tostring(#vim.fn.getbufinfo({ buflisted = 1 })) -- open buffer count

                    -- Messages from LSP servers.
                    local lsp_progress = require("lsp-progress").progress()

                    -- File details.
                    -- Only show encoding and format components for non-standard values.
                    local filencoding = (vim.bo.fileencoding ~= "utf-8" and vim.bo.fileencoding or nil)
                    local fileformat = (vim.bo.fileformat ~= "unix" and vim.bo.fileformat or nil)
                    local filetype = vim.bo.filetype

                    local cwd_basename = vim.fn.fnamemodify(vim.fn.getcwd(), ':t')

                    -- Compose groups and return the statusline string
                    return MS.combine_groups({
                        -- Left --
                        -- Mode-colored buffer ID, total number of buffers.
                        { hl = mode_hl,                 strings = { bufnum .. "/" .. bufcount } },
                        -- Gray. Project name inferred from CWD.
                        { hl = "MiniStatuslineDevinfo", strings = { cwd_basename } },
                        "%<", -- truncation marker
                        -- Black, filepath relative to nvim's cwd.
                        { hl = "MiniStatuslineFilename", strings = { get_filename() } },
                        "%=", -- split left/right
                        -- Right --
                        -- Gray. LSP client status + LSP warnings and errors + LSP summary + file encoding + ft
                        { hl = "MiniStatuslineDevinfo",  strings = { lsp_progress, diagnostics, lsp, filencoding, fileformat, filetype } },
                        -- Mode-colored, [1/7] 1C 2L 23% + line,col
                        { hl = mode_hl,                  strings = { search, get_visual_selection_info(), get_position_info() } },
                    })
                end,

                -- inactive windows: show simpler filename
                inactive = function()
                    return MS.combine_groups({
                        { hl = "MiniStatuslineFilename", strings = { get_filename() } },
                    })
                end,
            },
        })

        -- Hooks for updating status line
        local augroup = vim.api.nvim_create_augroup("LspProgressStatusline", { clear = true })
        vim.api.nvim_create_autocmd("User", {
          group = augroup,
          pattern = "LspProgressStatusUpdated",
          callback = function()
            vim.cmd("redrawstatus")
          end,
        })
    end,
}
