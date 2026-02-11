-- Emacs-like transpose-words for Neovim (approximate, but follows Emacs cursor semantics)
local M = {}

-- Get first match of "word" (alphanumeric + underscore) on line r starting at byte column >= start_byte.
-- Returns { row = <1-based>, s = <1-based byte start>, e = <1-based byte end>, text = <string> }
local function find_next_word_from_line(line, start_byte, row)
    for s, w in line:gmatch '()([%w_]+)' do
        local e = s + #w - 1
        if e >= start_byte then
            return { row = row, s = s, e = e, text = w }
        end
    end
    return nil
end

-- Search forward from (row, start_byte) inclusive for the next word (can be on later lines)
local function find_next_word(buf, row, start_byte)
    local linecount = vim.api.nvim_buf_line_count(buf)
    for r = row, linecount do
        local line = vim.api.nvim_buf_get_lines(buf, r - 1, r, false)[1] or ''
        local start_at = (r == row) and start_byte or 1
        local found = find_next_word_from_line(line, start_at, r)
        if found then
            return found
        end
    end
    return nil
end

-- Search backward from (row, start_byte) to find the previous word strictly before the cursor
-- or the last word on previous lines.
local function find_prev_word(buf, row, start_byte)
    for r = row, 1, -1 do
        local line = vim.api.nvim_buf_get_lines(buf, r - 1, r, false)[1] or ''
        local last = nil
        for s, w in line:gmatch '()([%w_]+)' do
            local e = s + #w - 1
            if r == row then
                if e < start_byte then
                    last = { row = r, s = s, e = e, text = w }
                elseif s <= start_byte and e >= start_byte then
                    -- cursor inside this word — previous is whatever we found earlier (last), break
                    break
                else
                    break
                end
            else
                -- earlier line: keep last occurrence on that line
                last = { row = r, s = s, e = e, text = w }
            end
        end
        if last then
            return last
        end
    end
    return nil
end

-- Replace region (row, s..e) where s,e are 1-based byte indices with newtext
local function replace_region(buf, row, s, e, newtext)
    local line = vim.api.nvim_buf_get_lines(buf, row - 1, row, false)[1] or ''
    local prefix = line:sub(1, s - 1)
    local suffix = line:sub(e + 1, -1)
    local newline = prefix .. newtext .. suffix
    vim.api.nvim_buf_set_lines(buf, row - 1, row, false, { newline })
end

-- Emacs semantics:
-- If point is inside a word -> that word is the "second" (right-hand) word to swap.
-- Else -> take first word AFTER point as the second.
-- Then swap the previous word (left) with that second word (right).
function M.transpose_words_emacs()
    local buf = vim.api.nvim_get_current_buf()
    local pos = vim.api.nvim_win_get_cursor(0) -- {row, col0}; col0 is 0-based byte index
    local row, col0 = pos[1], pos[2]
    local col_byte = col0 + 1 -- convert to 1-based byte index

    -- Determine the "second" word (the one at/after point if not inside a word,
    -- or the word containing point if inside).
    local second = find_next_word(buf, row, col_byte)
    -- If the cursor is inside a word, find_next_word will return that same word (since e >= col_byte)
    -- If no word after cursor, nothing to do.
    if not second then
        return
    end

    -- Find the "first" word (the previous word before that second word).
    -- If cursor was inside a word, we want the previous word BEFORE that.
    -- We'll search backward from the start of 'second'.
    local first = find_prev_word(buf, second.row, second.s)
    if not first then
        return
    end

    -- If both words are on the same line, rebuild preserving the between-text.
    if first.row == second.row then
        local line = vim.api.nvim_buf_get_lines(buf, first.row - 1, first.row, false)[1] or ''
        local a = line:sub(1, first.s - 1)
        local between = line:sub(first.e + 1, second.s - 1)
        local after = line:sub(second.e + 1, -1)
        local new = a .. second.text .. between .. first.text .. after
        vim.api.nvim_buf_set_lines(buf, first.row - 1, first.row, false, { new })
    else
        -- Cross-line swap: replace later region first (so earlier indices remain valid)
        replace_region(buf, second.row, second.s, second.e, first.text)
        replace_region(buf, first.row, first.s, first.e, second.text)
    end
end

-- Emacs also has a "backward" notion (swap previous word with current/next).
-- Implementing explicit "transpose before point" (like M-T) --
-- We'll choose: find previous word (the one before point), then find the word after it, and swap.
function M.transpose_words_emacs_backward()
    local buf = vim.api.nvim_get_current_buf()
    local pos = vim.api.nvim_win_get_cursor(0)
    local row, col0 = pos[1], pos[2]
    local col_byte = col0 + 1

    -- Find the previous word relative to cursor (the candidate left-hand side)
    local prev = find_prev_word(buf, row, col_byte)
    if not prev then
        return
    end

    -- Find the next word after prev (the right-hand side)
    local saved_cursor = vim.api.nvim_win_get_cursor(0)
    vim.api.nvim_win_set_cursor(0, { prev.row, prev.e - 1 }) -- set cursor near end of prev for consistent search
    local nextw = find_next_word(buf, prev.row, prev.e + 1)
    vim.api.nvim_win_set_cursor(0, saved_cursor)
    if not nextw then
        return
    end

    if prev.row == nextw.row then
        local line = vim.api.nvim_buf_get_lines(buf, prev.row - 1, prev.row, false)[1] or ''
        local a = line:sub(1, prev.s - 1)
        local between = line:sub(prev.e + 1, nextw.s - 1)
        local after = line:sub(nextw.e + 1, -1)
        local new = a .. nextw.text .. between .. prev.text .. after
        vim.api.nvim_buf_set_lines(buf, prev.row - 1, prev.row, false, { new })
    else
        replace_region(buf, nextw.row, nextw.s, nextw.e, prev.text)
        replace_region(buf, prev.row, prev.s, prev.e, nextw.text)
    end
end

-- Keymaps: normal & insert (insert does exit/perform/re-enter — approximate)
vim.keymap.set('n', '<M-t>', function()
    M.transpose_words_emacs()
end, { noremap = true, silent = true })
vim.keymap.set('n', '<M-T>', function()
    M.transpose_words_emacs_backward()
end, { noremap = true, silent = true })

vim.keymap.set('i', '<M-t>', function()
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', true)
    M.transpose_words_emacs()
    vim.api.nvim_feedkeys('a', 'n', true)
end, { noremap = true, silent = true })

vim.keymap.set('i', '<M-T>', function()
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', true)
    M.transpose_words_emacs_backward()
    vim.api.nvim_feedkeys('a', 'n', true)
end, { noremap = true, silent = true })

return M
