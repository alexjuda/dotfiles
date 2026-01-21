local M = {}

-- Visual mode: wrap selection as Markdown link using clipboard URL.
-- Result: [selected text](<clipboard>)
-- Put this in your init.lua (or any lua module you source).

M.wrap_visual_selection_as_md_link = function()
    -- Grab clipboard contents (uses + register; requires clipboard support)
    local url = vim.fn.getreg("+"):gsub("%s+$", "")
    if url == "" then
        vim.notify("Clipboard (+ register) is empty. Copy a URL first.", vim.log.levels.WARN)
        return
    end

    local mode = vim.fn.visualmode() -- 'v', 'V', or CTRL-V (block)
    if mode == "\022" then
        vim.notify("Blockwise visual mode not supported by this snippet.", vim.log.levels.WARN)
        return
    end

    -- Visual start position and current cursor position (1-based line/col)
    local vpos = vim.fn.getpos("v")
    local cpos = vim.fn.getpos(".")
    local srow, scol = vpos[2], vpos[3]
    local erow, ecol = cpos[2], cpos[3]

    -- Normalize ordering
    if (srow > erow) or (srow == erow and scol > ecol) then
        srow, erow = erow, srow
        scol, ecol = ecol, scol
    end

    -- Convert to 0-based indices for nvim_buf_get_text / set_text.
    local start_row = srow - 1
    local end_row   = erow - 1
    local start_col
    local end_col_excl

    if mode == "V" then
        -- Linewise: replace whole lines
        start_col = 0
        end_col_excl = vim.fn.col({ erow, "$" }) - 1 -- exclusive, 0-based
    else
        -- Charwise: columns are inclusive in getpos; end_col in buf API is exclusive.
        start_col = scol - 1
        end_col_excl = ecol -- (see reasoning: inclusive 1-based -> exclusive 0-based)
    end

    -- Get selected text (list of lines), join with \n
    local parts = vim.api.nvim_buf_get_text(0, start_row, start_col, end_row, end_col_excl, {})
    local text = table.concat(parts, "\n")

    -- Replace selection with markdown link
    local replacement = "[" .. text .. "](" .. url .. ")"
    vim.api.nvim_buf_set_text(0, start_row, start_col, end_row, end_col_excl, { replacement })

    -- Exit visual mode cleanly (optional)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
end

return M
