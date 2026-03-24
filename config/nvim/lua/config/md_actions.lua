local ts = require("config.text_selection")

local M = {}

---Format markdown link with text and URL
---@param text string The link text
---@param url string The link URL
---@return string
M.format_link = function(text, url)
    local replacement = "[" .. text .. "](" .. url .. ")"
    return replacement
end

---@return string
function M.get_clipboard()
    local reg = vim.fn.getreg("+")
    local replaced, _ = reg:gsub("%s+$", "")
    return replaced
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
    -- Remove query params if present (?foo=bar)
    title_seg = title_seg:gsub("?.+$", "")
    -- Remove UUID part if present (after last - followed by alphanum)
    title_seg = title_seg:gsub("-[a-f0-9]+$", ""):gsub("-", " ")
    -- Title case
    title_seg = title_seg:gsub("(%a)([%w_']*)", function(first, rest) return first:upper() .. rest:lower() end)
    return title_seg
end

---@param url string
---@return string|nil
local function extract_github_pr(url)
    local owner, repo = url:match("github%.com/([^/]+)/([^/]+)")
    local pr = url:match("github%.com/[^/]+/[^/]+/pull/(%d+)")
    if owner and repo then
        if pr then
            return owner .. "/" .. repo .. "#" .. pr
        else
            return owner .. "/" .. repo
        end
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

    local start_row, start_col, end_row, end_col = ts.get_visual_positions()
    local text = ts.get_text(0, start_row, start_col, end_row, end_col)
    local replacement = M.format_link(text, url)
    ts.replace_selection(0, start_row, start_col, end_row, end_col, replacement)
    ts.exit_visual_mode()
end

return M
