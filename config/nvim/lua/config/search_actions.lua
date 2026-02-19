local M = {}

---Escape characters for literal grep search
---@param text string
---@return string
local function escape_grep(text)
    -- Escape backslashes first
    text = text:gsub("\\", "\\\\")
    -- Escape quotes
    text = text:gsub('"', '\\"')
    -- Escape grep/shell special chars
    text = text:gsub("([%*%?%[%]%(%){%}%|%^%$%.%+%-])", "\\%1")
    return text
end

---Get the visually selected text as a string
local function get_selected_text()
    -- Get visual selection positions
    local start_pos = vim.fn.getpos("v") -- start of selection
    local end_pos = vim.fn.getpos(".") -- current cursor position

    -- Only single line
    local line = vim.fn.getline(start_pos[2])
    local col_start = math.min(start_pos[3], end_pos[3])
    local col_end = math.max(start_pos[3], end_pos[3])

    return line:sub(col_start, col_end)
end

---Prepare grep command with visually selected text as the search term.
function M.prefill_grep_visual()
    local selected_text = get_selected_text()

    -- Escape all special characters
    selected_text = escape_grep(selected_text)

    -- Exit visual mode
    vim.api.nvim_feedkeys(
        vim.api.nvim_replace_termcodes("<Esc>", true, false, true),
        "n",
        false
    )
    M.prefill_grep(selected_text)
end

---Prepare grep command with `text` as the search term.
---@param text string
function M.prefill_grep(text)
    -- Feed command prompt
    text = '"' .. text .. '"'
    local suffix = " *"
    vim.api.nvim_feedkeys(
        ":grep " .. text .. suffix,
        "n",
        true
    )

    -- Move back to the empty ""
    local left_moves = string.rep("<Left>", #suffix + 1)
    vim.api.nvim_feedkeys(
        vim.api.nvim_replace_termcodes(left_moves, true, false, true),
        "n",
        false
    )
end

---Prepare grep command with last searched text as the search term.
function M.prefill_grep_search_reg()
    local last_searched_text = vim.fn.getreg("/")
    M.prefill_grep(last_searched_text)
end

---Prepare quickfix replace command with visually selected text as the search term.
function M.prefill_cdo_visual()
    local selected_text = get_selected_text()
    M.prefill_cdo(selected_text)
end

---Prepare quickfix replace command with last searched text as the search term.
function M.prefill_cdo_search_reg()
    local last_searched_text = vim.fn.getreg("/")
    M.prefill_cdo(last_searched_text)
end

---Prepare quickfix update command with `text` as the search term.
---@param text string
function M.prefill_cdo(text)
    -- Escape all special characters
    text = escape_grep(text)

    -- Exit visual mode
    vim.api.nvim_feedkeys(
        vim.api.nvim_replace_termcodes("<Esc>", true, false, true),
        "n",
        false
    )

    -- Feed command prompt
    local suffix = "/cg"
    vim.api.nvim_feedkeys(
        ":cdo s/" .. text .. "//cg",
        "n",
        true
    )

    -- Move back to the empty ""
    local left_moves = string.rep("<Left>", #suffix)
    vim.api.nvim_feedkeys(
        vim.api.nvim_replace_termcodes(left_moves, true, false, true),
        "n",
        false
    )
end

---Open/close the quickfix window
function M.toggle_qf()
    local qf_exists = false
    for _, win in pairs(vim.fn.getwininfo()) do
        if win["quickfix"] == 1 then
            qf_exists = true
        end
    end
    if qf_exists == true then
        vim.cmd "cclose"
        return
    else
        vim.cmd "copen"
    end
end

return M
