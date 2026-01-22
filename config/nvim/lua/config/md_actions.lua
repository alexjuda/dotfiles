local M = {}

M.format_link = function(text, url)
    local replacement = "[" .. text .. "](" .. url .. ")"
    return replacement
end

function M.is_visual_mode_supported(mode)
    return mode ~= "\022"
end

function M.get_url_from_clipboard()
    return vim.fn.getreg("+"):gsub("%s+$", "")
end

function M.get_visual_positions()
    local vpos = vim.fn.getpos("v")
    local cpos = vim.fn.getpos(".")
    return vpos[2], vpos[3], cpos[2], cpos[3]
end

function M.normalize_positions(srow, scol, erow, ecol)
    if (srow > erow) or (srow == erow and scol > ecol) then
        return erow, ecol, srow, scol
    else
        return srow, scol, erow, ecol
    end
end

function M.convert_to_api_indices(mode, srow, scol, erow, ecol)
    local start_row = srow - 1
    local end_row = erow - 1
    local start_col, end_col_excl
    if mode == "V" then
        start_col = 0
        end_col_excl = vim.fn.col({erow, "$"}) - 1
    else
        start_col = scol - 1
        end_col_excl = ecol
    end
    return start_row, start_col, end_row, end_col_excl
end

function M.get_selected_text(bufnr, start_row, start_col, end_row, end_col_excl)
    local parts = vim.api.nvim_buf_get_text(bufnr, start_row, start_col, end_row, end_col_excl, {})
    return table.concat(parts, "\n")
end

function M.replace_selection(bufnr, start_row, start_col, end_row, end_col_excl, replacement)
    vim.api.nvim_buf_set_text(bufnr, start_row, start_col, end_row, end_col_excl, {replacement})
end

function M.exit_visual_mode()
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
end

function M.is_url(str)
    return str:match("^https?://") ~= nil
end

function M.is_jira_url(url)
    return url:match("/browse/[A-Z]+%-[0-9]+") ~= nil
end

function M.extract_jira_ticket(url)
    local ticket = url:match("/browse/([A-Z]+%-[0-9]+)")
    return ticket
end

function M.is_notion_url(url)
    return url:match("notion%.so") ~= nil
end

function M.get_notion_title(url)
    -- Extract title from URL path, e.g., https://notion.so/workspace/My-Page-Title-abc123 -> My Page Title
    local path = url:match("notion%.so/(.+)")
    if not path then return "Notion Page" end
    -- Split by / and take the last segment
    local segments = {}
    for seg in path:gmatch("[^/]+") do
        table.insert(segments, seg)
    end
    local title_seg = segments[#segments] or ""
    -- Remove UUID part if present (after last - followed by alphanum)
    title_seg = title_seg:gsub("-[a-f0-9]+$", ""):gsub("-", " ")
    -- Title case
    title_seg = title_seg:gsub("(%a)([%w_']*)", function(first, rest) return first:upper() .. rest:lower() end)
    return title_seg
end

function M.extract_domain(url)
    local domain = url:match("https?://([^/]+)")
    return domain
end

function M.paste_md_link_from_clipboard()
    local url = M.get_url_from_clipboard()
    if not M.is_url(url) then
        return
    end

    local summary
    if M.is_jira_url(url) then
        summary = M.extract_jira_ticket(url)
    elseif M.is_notion_url(url) then
        summary = M.get_notion_title(url)
    else
        summary = M.extract_domain(url)
    end

    local link = M.format_link(summary, url)
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    vim.api.nvim_buf_set_text(0, row-1, col, row-1, col, {link})
end

-- Visual mode: wrap selection as Markdown link using clipboard URL.
-- Result: [selected text](<clipboard>)
-- Put this in your init.lua (or any lua module you source).

M.wrap_visual_selection_as_md_link = function()
    local url = M.get_url_from_clipboard()
    if url == "" then
        vim.notify("Clipboard (+ register) is empty. Copy a URL first.", vim.log.levels.WARN)
        return
    end

    local mode = vim.fn.visualmode()
    if not M.is_visual_mode_supported(mode) then
        vim.notify("Blockwise visual mode not supported by this snippet.", vim.log.levels.WARN)
        return
    end

    local srow, scol, erow, ecol = M.get_visual_positions()
    srow, scol, erow, ecol = M.normalize_positions(srow, scol, erow, ecol)
    local start_row, start_col, end_row, end_col_excl = M.convert_to_api_indices(mode, srow, scol, erow, ecol)
    local text = M.get_selected_text(0, start_row, start_col, end_row, end_col_excl)
    local replacement = M.format_link(text, url)
    M.replace_selection(0, start_row, start_col, end_row, end_col_excl, replacement)
    M.exit_visual_mode()
end

return M
