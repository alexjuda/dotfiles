local assert = require('luassert')
local describe = require('plenary.busted').describe
local it = require('plenary.busted').it

describe('text_selection', function()
    local text_selection

    before_each(function()
        text_selection = require('config.text_selection')
    end)

    describe('get_visual_positions integration', function()
        local test_buf

        before_each(function()
            test_buf = vim.api.nvim_create_buf(false, true)
            vim.api.nvim_buf_set_lines(test_buf, 0, -1, false, {
                'line one',
                'line  two',
                'line three'
            })
            vim.api.nvim_win_set_buf(0, test_buf)
        end)

        after_each(function()
            if test_buf and vim.api.nvim_buf_is_valid(test_buf) then
                vim.api.nvim_buf_delete(test_buf, {force = true})
            end
        end)

        it('character visual mode, forward selection, same line', function()
            vim.api.nvim_win_set_cursor(0, {1, 0})
            vim.cmd('normal! v4l')
            local srow, scol, erow, ecol = text_selection.get_visual_positions()
            assert.are.equal(1, srow)
            assert.are.equal(1, scol)
            assert.are.equal(1, erow)
            assert.are.equal(5, ecol)
            vim.cmd('normal! \\<Esc>')
        end)

        it('character visual mode, forward selection, different lines', function()
            vim.api.nvim_win_set_cursor(0, {1, 0})
            vim.cmd('normal! v4lj')
            local srow, scol, erow, ecol = text_selection.get_visual_positions()
            assert.are.equal(1, srow)
            assert.are.equal(1, scol)
            assert.are.equal(2, erow)
            assert.are.equal(5, ecol)
            vim.cmd('normal! \\<Esc>')
        end)

        it('character visual mode, backward selection, same line', function()
            vim.api.nvim_win_set_cursor(0, {1, 4})
            vim.cmd('normal! v4h')
            local srow, scol, erow, ecol = text_selection.get_visual_positions()
            assert.are.equal(1, srow)
            assert.are.equal(1, scol)
            assert.are.equal(1, erow)
            assert.are.equal(5, ecol)
            vim.cmd('normal! \\<Esc>')
        end)

        it('character visual mode, backward selection, different lines', function()
            vim.api.nvim_win_set_cursor(0, {2, 4})
            vim.cmd('normal! v4hk')
            local srow, scol, erow, ecol = text_selection.get_visual_positions()
            assert.are.equal(1, srow)
            assert.are.equal(1, scol)
            assert.are.equal(2, erow)
            assert.are.equal(5, ecol)
            vim.cmd('normal! \\<Esc>')
        end)

        it('line visual mode', function()
            vim.api.nvim_win_set_cursor(0, {1, 0})
            vim.cmd('normal! Vj')
            local srow, scol, erow, ecol = text_selection.get_visual_positions()
            assert.are.equal(1, srow)
            assert.are.equal(1, scol)
            assert.are.equal(2, erow)
            assert.are.equal(9, ecol)
            vim.cmd('normal! \\<Esc>')
        end)

        it('handles multi-line selection', function()
            vim.api.nvim_win_set_cursor(0, {1, 0})
            vim.cmd('normal! v2j4l')
            local srow, scol, erow, ecol = text_selection.get_visual_positions()
            assert.are.equal(1, srow)
            assert.are.equal(1, scol)
            assert.are.equal(3, erow)
            assert.are.equal(5, ecol)
            vim.cmd('normal! \\<Esc>')
        end)
    end)

    describe('get_selected_text', function()
        local test_buf

        before_each(function()
            test_buf = vim.api.nvim_create_buf(false, true)
            vim.api.nvim_buf_set_lines(test_buf, 0, -1, false, {
                'line one',
                'line  two',
                'line three'
            })
        end)

        after_each(function()
            if test_buf and vim.api.nvim_buf_is_valid(test_buf) then
                vim.api.nvim_buf_delete(test_buf, {force = true})
            end
        end)

        it('within single line', function()
            local text = text_selection.get_text(test_buf, 1, 1, 1, 5)
            assert.are.equal('line ', text)
        end)

        it('single char', function()
            local text = text_selection.get_text(test_buf, 1, 1, 1, 1)
            assert.are.equal('l', text)
        end)

        it('spanning multiple lines', function()
            local text = text_selection.get_text(test_buf, 1, 1, 2, 5)
            assert.are.equal('line one\nline ', text)
        end)

        it('entire line in line-visual style (full line)', function()
            local text = text_selection.get_text(test_buf, 1, 1, 1, 9)
            assert.are.equal('line one', text)
        end)

        it('text from middle of line', function()
            local text = text_selection.get_text(test_buf, 1, 5, 1, 9)
            assert.are.equal(' one', text)
        end)

        it('returns empty string for zero-width selection', function()
            local text = text_selection.get_text(test_buf, 1, 3, 1, 2)
            assert.are.equal('', text)
        end)
    end)

    describe('replace_selection', function()
        local test_buf

        before_each(function()
            test_buf = vim.api.nvim_create_buf(false, true)
            vim.api.nvim_buf_set_lines(test_buf, 0, -1, false, {
                'line one',
                'line  two',
                'line three'
            })
        end)

        after_each(function()
            if test_buf and vim.api.nvim_buf_is_valid(test_buf) then
                vim.api.nvim_buf_delete(test_buf, {force = true})
            end
        end)

        it('replaces text within single line', function()
            text_selection.replace_selection(test_buf, 1, 1, 1, 4, 'replace')
            local text = text_selection.get_text(test_buf, 1, 1, 1, 20)
            assert.are.equal('replace one', text)
        end)

        it('replaces single character', function()
            text_selection.replace_selection(test_buf, 1, 1, 1, 1, 'X')
            local text = text_selection.get_text(test_buf, 1, 1, 1, 20)
            assert.are.equal('Xine one', text)
        end)

        it('replaces text spanning multiple lines', function()
            text_selection.replace_selection(test_buf, 1, 1, 2, 4, 'REPLACED')
            local lines = vim.api.nvim_buf_get_lines(test_buf, 0, -1, false)
            assert.are.same({
                'REPLACED  two',
                'line three'
            }, lines)
        end)

        it('replaces entire line', function()
            text_selection.replace_selection(test_buf, 1, 1, 1, 8, 'full line')
            local text = text_selection.get_text(test_buf, 1, 1, 1, 20)
            assert.are.equal('full line', text)
        end)

        it('replaces text from middle of line', function()
            text_selection.replace_selection(test_buf, 1, 6, 1, 8, 'REPLACED')
            local text = text_selection.get_text(test_buf, 1, 1, 1, 20)
            assert.are.equal('line REPLACED', text)
        end)
    end)

    describe('exit_visual_mode', function()
        local test_buf

        before_each(function()
            test_buf = vim.api.nvim_create_buf(false, true)
            vim.api.nvim_buf_set_lines(test_buf, 0, -1, false, {
                'line one',
                'line  two',
                'line three'
            })
        end)

        after_each(function()
            if test_buf and vim.api.nvim_buf_is_valid(test_buf) then
                vim.api.nvim_buf_delete(test_buf, {force = true})
            end
        end)

        it('changes mode', function()
            vim.cmd('normal! v')
            local mode1 = vim.fn.mode()

            text_selection.exit_visual_mode()

            local mode2 = vim.fn.mode()
            assert.are.equal('v', mode1)
            assert.are.equal('n', mode2)
        end)

        it('doesnt alter text', function()
            local line1 = vim.api.nvim_get_current_line()
            text_selection.exit_visual_mode()
            local line2 = vim.api.nvim_get_current_line()
            assert.are.equal(line2, line1)
        end)
    end)
end)
