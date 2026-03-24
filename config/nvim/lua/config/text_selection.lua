local M = {}

---Get visual selection start and end positions. 1-based indexes. `ecol` is exclusive.
---@return integer start_row, integer start_col, integer end_row, integer end_col
function M.get_visual_positions()
    -- `vim.fn` functions all return 1-based positions.
    local v_pos = vim.fn.getpos("v")
    local cur_pos = vim.fn.getpos(".")

    local start_row
    local start_col
    local end_row
    local end_col

    local mode = vim.fn.mode()
    if mode == "V" then
        _, start_row, _, _ = unpack(v_pos)
        _, end_row, _, _ = unpack(cur_pos)
        -- In line-visual mode, we want the entire line, not cursor positions
        start_col = 1
        end_col = vim.fn.col({end_row, "$"}) - 1
    else
        _, start_row, start_col, _ = unpack(v_pos)
        _, end_row, end_col, _ = unpack(cur_pos)
    end

    -- We need to normalize against backward selections.
    if (start_row > end_row) or (start_row == end_row and start_col > end_col) then
        -- Flip start and end.
        return end_row, end_col, start_row, start_col
    else
        -- Return normally.
        return start_row, start_col, end_row, end_col
    end
end


---Read text based on indices. All 1-based.
---@param bufnr integer Buffer number
---@param start_row integer Start row
---@param start_col integer Start column
---@param end_row integer End row (inclusive)
---@param end_col integer End column (inclusive)
---@return string
function M.get_text(bufnr, start_row, start_col, end_row, end_col)
    local parts = vim.api.nvim_buf_get_text(bufnr, start_row - 1, start_col - 1, end_row - 1, end_col, {})
    return table.concat(parts, "\n")
end


---Replace text within positions with a replacement. All indices are 1-based.
---@param bufnr integer Buffer number
---@param start_row integer Start row
---@param start_col integer Start column
---@param end_row integer End row, before the replacement (inclusive)
---@param end_col integer End column, before the replacement (inclusive)
---@param replacement string
function M.replace_selection(bufnr, start_row, start_col, end_row, end_col, replacement)
    vim.api.nvim_buf_set_text(bufnr, start_row - 1, start_col - 1, end_row - 1, end_col, { replacement })
end


function M.exit_visual_mode()
    local esc = vim.api.nvim_replace_termcodes('<esc>', true, false, true)
    vim.api.nvim_feedkeys(esc, 'x', false)
end


return M
