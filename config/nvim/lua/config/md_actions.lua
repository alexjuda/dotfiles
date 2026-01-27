local M = {}

---Format markdown link with text and URL
---@param text string The link text
---@param url string The link URL
---@return string
M.format_link = function(text, url)
    local replacement = "[" .. text .. "](" .. url .. ")"
    return replacement
end

---@param mode string The visual mode character
---@return boolean supported
function M.is_visual_mode_supported(mode)
    return mode ~= "\022" and mode ~= ""
end

---@return string
function M.get_clipboard()
    local reg = vim.fn.getreg("+")
    local replaced, _ = reg:gsub("%s+$", "")
    return replaced
end

---Get visual selection start and end positions (1-indexed)
---@return integer start_row, integer start_col, integer end_row, integer end_col
function M.get_visual_positions()
    local vpos = vim.fn.getpos("v")
    local cpos = vim.fn.getpos(".")

    local mode = vim.fn.visualmode()
    if mode == "V" then
        -- In line-visual mode, we want the entire line, not cursor positions
        local srow = vpos[2]
        local erow = cpos[2]
        return srow, 1, erow, vim.fn.col({erow, "$"}) - 1
    end

    return vpos[2], vpos[3], cpos[2], cpos[3]
end

---Normalize positions to ensure start comes before end (1-indexed)
---@param srow integer Start row (1-indexed)
---@param scol integer Start column (1-indexed)
---@param erow integer End row (1-indexed)
---@param ecol integer End column (1-indexed)
---@return integer norm_start_row, integer norm_start_col, integer norm_end_row, integer norm_end_col
function M.normalize_positions(srow, scol, erow, ecol)
    if (srow > erow) or (srow == erow and scol > ecol) then
        return erow, ecol, srow, scol
    else
        return srow, scol, erow, ecol
    end
end

---Convert visual mode positions to 0-indexed API indices
---@param srow integer Start row (1-indexed)
---@param scol integer Start column (1-indexed)
---@param erow integer End row (1-indexed)
---@param ecol integer End column (1-indexed)
---@return integer api_start_row, integer api_start_col, integer api_end_row, integer api_end_col_excl
function M.convert_to_api_indices(srow, scol, erow, ecol)
    local start_row = srow - 1
    local end_row = erow - 1
    local start_col = scol - 1
    local end_col_excl = ecol
    return start_row, start_col, end_row, end_col_excl
end

---Get selected text from buffer
---@param bufnr integer Buffer number
---@param start_row integer Start row (0-indexed)
---@param start_col integer Start column (0-indexed)
---@param end_row integer End row (0-indexed)
---@param end_col_excl integer End column (0-indexed, exclusive)
---@return string selected_text
function M.get_selected_text(bufnr, start_row, start_col, end_row, end_col_excl)
    local parts = vim.api.nvim_buf_get_text(bufnr, start_row, start_col, end_row, end_col_excl, {})
    return table.concat(parts, "\n")
end

---Replace selected text with replacement
---@param bufnr integer Buffer number
---@param start_row integer Start row (0-indexed)
---@param start_col integer Start column (0-indexed)
---@param end_row integer End row (0-indexed)
---@param end_col_excl integer End column (0-indexed, exclusive)
---@param replacement string Replacement text
function M.replace_selection(bufnr, start_row, start_col, end_row, end_col_excl, replacement)
    vim.api.nvim_buf_set_text(bufnr, start_row, start_col, end_row, end_col_excl, {replacement})
end

function M.exit_visual_mode()
    vim.api.nvim_input("<Esc>")
end

---Check if string is a URL
---@param str string String to check
---@return boolean is_url
function M.is_url(str)
    return str:match("^https?://") ~= nil
end

---@param url string
---@return string|nil
local function extract_jira_ticket(url)
    local ticket = url:match("/browse/([A-Z]+%-[0-9]+)")
    return ticket
end

---@param url string
---@return string|nil
local function get_notion_title(url)
    if url:match("notion%.so") == nil then
        return nil
    end

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

---@param url string
---@return string|nil
local function extract_github_pr(url)
    local owner, repo, pr = url:match("github%.com/([^/]+)/([^/]+)/pull/(%d+)")
    if owner and repo and pr then
        return owner .. "/" .. repo .. "#" .. pr
    end
    return nil
end

---Extract other, unknown domain
---@param url string
---@return string|nil
local function extract_domain(url)
    local domain = url:match("https?://([^/]+)")
    return domain
end

---Extract link summary from URL using heuristics for known patterns.
---@param link string
---@return string
function M.extract_summary(link)
    return get_notion_title(link) or extract_jira_ticket(link) or extract_github_pr(link) or extract_domain(link) or link
end

---Paste markdown link from clipboard at cursor position
function M.paste_md_link_from_clipboard()
    local url = M.get_clipboard()
    if not M.is_url(url) then
        vim.notify("Contents of the register \"+ is not a valid URL", vim.log.levels.WARN)
        return
    end

    local summary = M.extract_summary(url)

    local link = M.format_link(summary, url)

    vim.api.nvim_paste(link, false, -1)
end

---Wrap visual selection as markdown link using clipboard URL
---Visual mode: wrap selection as Markdown link using clipboard URL.
---Result: [selected text](<clipboard>)
---Put this in your init.lua (or any lua module you source).
M.wrap_visual_selection_as_md_link = function()
    local url = M.get_clipboard()
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
    local start_row, start_col, end_row, end_col_excl = M.convert_to_api_indices(srow, scol, erow, ecol)
    local text = M.get_selected_text(0, start_row, start_col, end_row, end_col_excl)
    local replacement = M.format_link(text, url)
    M.replace_selection(0, start_row, start_col, end_row, end_col_excl, replacement)
    M.exit_visual_mode()
end

return M
