local assert = require('luassert')
local describe = require('plenary.busted').describe
local it = require('plenary.busted').it
local stub = require('luassert.stub')

describe('md_actions', function()
    local md_actions

    before_each(function()
        md_actions = require('config.md_actions')
    end)

    describe('format_link', function()
        it('formats text and url into markdown link', function()
            assert.are.equal('[hello](https://example.com)', md_actions.format_link('hello', 'https://example.com'))
            assert.are.equal('[](url)', md_actions.format_link('', 'url'))
            assert.are.equal('[text with spaces](url with spaces)',
                md_actions.format_link('text with spaces', 'url with spaces'))
        end)
    end)

    describe('is_visual_mode_supported', function()
        it('returns true for character and line visual modes', function()
            assert.is_true(md_actions.is_visual_mode_supported('v'))
            assert.is_true(md_actions.is_visual_mode_supported('V'))
        end)

        it('returns false for blockwise visual mode', function()
            assert.is_false(md_actions.is_visual_mode_supported('\022'))
        end)

        it('returns false for initial mode', function()
            assert.is_false(md_actions.is_visual_mode_supported(''))
        end)
    end)

    describe('get_clipboard', function()
        it('gets URL from clipboard and trims trailing spaces', function()
            stub(vim.fn, 'getreg')
            vim.fn.getreg.returns('https://example.com   ')
            local url = md_actions.get_clipboard()
            assert.are.equal('https://example.com', url)
            vim.fn.getreg:revert()
        end)

        it('returns empty string if clipboard empty', function()
            stub(vim.fn, 'getreg')
            vim.fn.getreg.returns('')
            local url = md_actions.get_clipboard()
            assert.are.equal('', url)
            vim.fn.getreg:revert()
        end)
    end)

    describe('normalize_positions', function()
        it('returns positions as is if start before end', function()
            local srow, scol, erow, ecol = md_actions.normalize_positions(1, 1, 2, 1)
            assert.are.equal(1, srow)
            assert.are.equal(1, scol)
            assert.are.equal(2, erow)
            assert.are.equal(1, ecol)
        end)

        it('swaps positions if start after end', function()
            local srow, scol, erow, ecol = md_actions.normalize_positions(2, 1, 1, 1)
            assert.are.equal(1, srow)
            assert.are.equal(1, scol)
            assert.are.equal(2, erow)
            assert.are.equal(1, ecol)
        end)

        it('swaps positions if same row but start col after end col', function()
            local srow, scol, erow, ecol = md_actions.normalize_positions(1, 3, 1, 1)
            assert.are.equal(1, srow)
            assert.are.equal(1, scol)
            assert.are.equal(1, erow)
            assert.are.equal(3, ecol)
        end)
    end)

    describe('get_visual_positions', function()
        it('gets visual positions for character mode', function()
            stub(vim.fn, 'getpos')
            stub(vim.fn, 'visualmode').returns('v')
            vim.fn.getpos.on_call_with('v').returns({0, 2, 5, 0})
            vim.fn.getpos.on_call_with('.').returns({0, 3, 10, 0})

            local srow, scol, erow, ecol = md_actions.get_visual_positions()
            assert.are.equal(2, srow)
            assert.are.equal(5, scol)
            assert.are.equal(3, erow)
            assert.are.equal(10, ecol)

            vim.fn.getpos:revert()
            vim.fn.visualmode:revert()
        end)

        it('gets full line positions for line visual mode', function()
            stub(vim.fn, 'getpos')
            stub(vim.fn, 'visualmode').returns('V')
            stub(vim.fn, 'col')
            vim.fn.getpos.on_call_with('v').returns({0, 2, 5, 0})
            vim.fn.getpos.on_call_with('.').returns({0, 3, 1, 0})
            vim.fn.col.returns(20)

            local srow, scol, erow, ecol = md_actions.get_visual_positions()
            assert.are.equal(2, srow)
            assert.are.equal(1, scol)
            assert.are.equal(3, erow)
            assert.are.equal(19, ecol)  -- 20 - 1

            vim.fn.getpos:revert()
            vim.fn.visualmode:revert()
            vim.fn.col:revert()
        end)
    end)

    describe('convert_to_api_indices', function()
        it('converts 1-indexed positions to 0-indexed API indices', function()
            local start_row, start_col, end_row, end_col_excl = md_actions.convert_to_api_indices(1, 1, 1, 3)
            assert.are.equal(0, start_row)
            assert.are.equal(0, start_col)
            assert.are.equal(0, end_row)
            assert.are.equal(3, end_col_excl)
        end)

        it('converts multi-line positions', function()
            local start_row, start_col, end_row, end_col_excl = md_actions.convert_to_api_indices(2, 5, 4, 10)
            assert.are.equal(1, start_row)
            assert.are.equal(4, start_col)
            assert.are.equal(3, end_row)
            assert.are.equal(10, end_col_excl)
        end)
    end)

    describe('get_selected_text', function()
        it('gets text from buffer', function()
            stub(vim.api, 'nvim_buf_get_text')
            vim.api.nvim_buf_get_text.returns({'hello', 'world'})
            local text = md_actions.get_selected_text(0, 0, 0, 1, 5)
            assert.are.equal('hello\nworld', text)
            vim.api.nvim_buf_get_text:revert()
        end)
    end)

    describe('replace_selection', function()
        it('replaces text in buffer', function()
            stub(vim.api, 'nvim_buf_set_text')
            md_actions.replace_selection(0, 0, 0, 1, 5, 'replacement')
            assert.stub(vim.api.nvim_buf_set_text).was_called_with(0, 0, 0, 1, 5, {'replacement'})
            vim.api.nvim_buf_set_text:revert()
        end)
    end)

    describe('wrap_visual_selection_as_md_link', function()
        it('wraps selection as markdown link', function()
            -- Mock all dependencies
            stub(md_actions, 'get_clipboard').returns('https://example.com')
            stub(vim.fn, 'visualmode').returns('v')
            stub(md_actions, 'is_visual_mode_supported').returns(true)
            stub(md_actions, 'get_visual_positions').returns(1, 1, 1, 5)
            stub(md_actions, 'normalize_positions').returns(1, 1, 1, 5)
            stub(md_actions, 'convert_to_api_indices').returns(0, 0, 0, 5)
            stub(md_actions, 'get_selected_text').returns('hello')
            stub(md_actions, 'format_link').returns('[hello](https://example.com)')
            stub(md_actions, 'replace_selection')
            stub(md_actions, 'exit_visual_mode')

            md_actions.wrap_visual_selection_as_md_link()

            assert.stub(md_actions.get_clipboard).was_called()
            assert.stub(vim.fn.visualmode).was_called()
            assert.stub(md_actions.is_visual_mode_supported).was_called_with('v')
            assert.stub(md_actions.get_visual_positions).was_called()
            assert.stub(md_actions.normalize_positions).was_called_with(1, 1, 1, 5)
            assert.stub(md_actions.convert_to_api_indices).was_called_with(1, 1, 1, 5)
            assert.stub(md_actions.get_selected_text).was_called_with(0, 0, 0, 0, 5)
            assert.stub(md_actions.format_link).was_called_with('hello', 'https://example.com')
            assert.stub(md_actions.replace_selection).was_called_with(0, 0, 0, 0, 5, '[hello](https://example.com)')
            assert.stub(md_actions.exit_visual_mode).was_called()

            -- Revert all stubs
            md_actions.get_clipboard:revert()
            vim.fn.visualmode:revert()
            md_actions.is_visual_mode_supported:revert()
            md_actions.get_visual_positions:revert()
            md_actions.normalize_positions:revert()
            md_actions.convert_to_api_indices:revert()
            md_actions.get_selected_text:revert()
            md_actions.format_link:revert()
            md_actions.replace_selection:revert()
            md_actions.exit_visual_mode:revert()
        end)

        it('warns if clipboard is empty', function()
            stub(md_actions, 'get_clipboard').returns('')
            stub(vim, 'notify')

            md_actions.wrap_visual_selection_as_md_link()

            assert.stub(vim.notify).was_called_with("Clipboard (+ register) is empty. Copy a URL first.", vim.log.levels.WARN)

            md_actions.get_clipboard:revert()
            vim.notify:revert()
        end)
    end)

    describe('is_url', function()
        it('returns true for http urls', function()
            assert.is_true(md_actions.is_url('http://example.com'))
            assert.is_true(md_actions.is_url('https://example.com'))
        end)

        it('returns false for non-url strings', function()
            assert.is_false(md_actions.is_url('hello world'))
            assert.is_false(md_actions.is_url('ftp://example.com'))
            assert.is_false(md_actions.is_url(''))
        end)
    end)

    describe('extract_summary', function()
        describe('with notion link', function()
            it('extracts title from notion url', function()
                local title = md_actions.extract_summary('https://www.notion.so/workspace/My-Page-Title-1234567890abcdef')
                assert.are.equal('My Page Title', title)
            end)

            it('returns default if no path', function()
                local title = md_actions.extract_summary('https://notion.so')
                assert.are.equal('Notion Page', title)
            end)
        end)

        it('extracts ticket from jira url', function()
            assert.are.equal('PROJ-123', md_actions.extract_summary('https://company.atlassian.net/browse/PROJ-123'))
            assert.are.equal('TICKET-456', md_actions.extract_summary('https://jira.example.com/browse/TICKET-456?param=value'))
        end)

        it('extracts PR from GitHub url', function()
            assert.are.equal('owner/repo#123', md_actions.extract_summary('https://github.com/owner/repo/pull/123'))
        end)

        it('extracts domain from unknown url', function()
            assert.are.equal('example.com', md_actions.extract_summary('https://example.com/path'))
            assert.are.equal('sub.example.com', md_actions.extract_summary('https://sub.example.com'))
            assert.are.equal('example.co.uk', md_actions.extract_summary('http://example.co.uk/test'))
        end)

        it('inserts full link if not a URL', function()
            assert.are.equal('tcp://foobar', md_actions.extract_summary('tcp://foobar'))
        end)
    end)

    describe('paste_md_link_from_clipboard integration', function()
        local test_buf

        before_each(function()
            -- Create a new buffer for each test
            test_buf = vim.api.nvim_create_buf(false, true)
            vim.api.nvim_buf_set_lines(test_buf, 0, -1, false, {'', ''})
            vim.api.nvim_win_set_buf(0, test_buf)
            vim.api.nvim_win_set_cursor(0, {1, 0})
        end)

        after_each(function()
            -- Clean up the test buffer
            if test_buf and vim.api.nvim_buf_is_valid(test_buf) then
                vim.api.nvim_buf_delete(test_buf, {force = true})
            end
        end)

        it('pastes jira link at cursor position', function()
            -- Set clipboard content
            vim.fn.setreg('+', 'https://company.atlassian.net/browse/PROJ-123')

            -- Call the function
            md_actions.paste_md_link_from_clipboard()

            -- Check the buffer content
            local lines = vim.api.nvim_buf_get_lines(test_buf, 0, -1, false)
            assert.are.equal('[PROJ-123](https://company.atlassian.net/browse/PROJ-123)', lines[1])
        end)

        it('warns if clipboard is not a url', function()
            -- Clear messages first
            vim.cmd('messages clear')

            -- Set clipboard content to non-URL
            vim.fn.setreg('+', 'not a url')

            -- Get initial buffer content
            local initial_lines = vim.api.nvim_buf_get_lines(test_buf, 0, -1, false)

            -- Call the function
            md_actions.paste_md_link_from_clipboard()

            -- Check that buffer content hasn't changed
            local final_lines = vim.api.nvim_buf_get_lines(test_buf, 0, -1, false)
            assert.are.same(initial_lines, final_lines)

            -- Check that warning message appears in messages
            local messages = vim.fn.execute('messages')
            assert.is_not_nil(messages:find("not a valid URL"))
        end)
    end)
end)
