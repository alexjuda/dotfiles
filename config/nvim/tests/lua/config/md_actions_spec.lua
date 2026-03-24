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

    describe('wrap_visual_selection_as_md_link', function()
        local test_buf

        before_each(function()
            test_buf = vim.api.nvim_create_buf(false, true)
            vim.api.nvim_buf_set_lines(test_buf, 0, -1, false, {
                'some text here',
                'another line'
            })
            vim.api.nvim_win_set_buf(0, test_buf)
        end)

        after_each(function()
            if test_buf and vim.api.nvim_buf_is_valid(test_buf) then
                vim.api.nvim_buf_delete(test_buf, {force = true})
            end
        end)

        it('wraps selected text with URL from clipboard', function()
            vim.api.nvim_win_set_cursor(0, {1, 5})
            vim.cmd('normal! ve')
            vim.fn.setreg('+', 'https://example.com')
            md_actions.wrap_visual_selection_as_md_link()
            local lines = vim.api.nvim_buf_get_lines(test_buf, 0, -1, false)
            assert.are.equal('some [text](https://example.com) here', lines[1])
        end)

        it('warns if clipboard is empty', function()
            vim.api.nvim_win_set_cursor(0, {1, 0})
            vim.cmd('normal! v4l')
            vim.fn.setreg('+', '')
            vim.cmd('messages clear')
            md_actions.wrap_visual_selection_as_md_link()
            local messages = vim.fn.execute('messages')
            assert.is_true(messages:find("empty") ~= nil)
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
                assert.are.equal('My Page Title', md_actions.extract_summary('https://www.notion.so/workspace/My-Page-Title-abcd1234567890abcdef'))
            end)

            it('strips query params', function()
                assert.are.equal('My Page Title', md_actions.extract_summary('https://www.notion.so/workspace/My-Page-Title-abcd1234567890abcdef?action=Copy_Link'))
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

        it('extracts repo from GitHub url', function()
            assert.are.equal('owner/repo', md_actions.extract_summary('https://github.com/owner/repo'))
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
