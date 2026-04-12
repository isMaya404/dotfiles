local api = vim.api
local M = { terminals = {} }

local function safe_close_win(win)
    if win and api.nvim_win_is_valid(win) then
        pcall(api.nvim_win_close, win, true)
    end
end

-- Open a terminal in the given position
function M._open_window(buf, pos, id)
    local win
    if pos == 'vsp' then
        vim.cmd 'vsplit'
        win = api.nvim_get_current_win()
        api.nvim_win_set_width(win, math.floor(vim.o.columns * 0.25))
    elseif pos == 'sp' then
        vim.cmd 'split'
        win = api.nvim_get_current_win()
        api.nvim_win_set_height(win, 15)
    elseif pos == 'float' then
        local w, h = math.floor(vim.o.columns * 0.7), math.floor(vim.o.lines * 0.7)
        win = api.nvim_open_win(buf, true, {
            relative = 'editor',
            width = w,
            height = h,
            row = math.floor((vim.o.lines - h) / 2),
            col = math.floor((vim.o.columns - w) / 2),
            style = 'minimal',
            border = 'rounded',
        })
    else
        error(("Invalid pos %q; use 'vsp','sp', or 'float'"):format(pos))
    end

    api.nvim_win_set_buf(win, buf)
    M.terminals[id].win = win

    -- Start terminal if empty
    if api.nvim_buf_line_count(buf) <= 1 and api.nvim_buf_get_lines(buf, 0, 1, false)[1] == '' then
        api.nvim_buf_call(buf, function()
            vim.cmd 'terminal'
        end)
        pcall(api.nvim_buf_set_name, buf, '__BufTerm__' .. id)
    end

    vim.cmd 'startinsert'
end

-- Toggle terminal
function M.toggle(opts)
    opts = opts or {}
    local pos = opts.pos or 'sp'
    local id = opts.id or 'default'

    M.terminals[id] = M.terminals[id] or {}
    local data = M.terminals[id]

    -- If window exists, just close it
    if data.win and api.nvim_win_is_valid(data.win) then
        safe_close_win(data.win)
        data.win = nil
        return
    end

    -- Create buffer if needed
    if not data.buf or not api.nvim_buf_is_valid(data.buf) then
        data.buf = api.nvim_create_buf(false, true)
        api.nvim_set_option_value('buflisted', false, { buf = data.buf })
        api.nvim_set_option_value('bufhidden', 'hide', { buf = data.buf })

        -- Clean up window on terminal exit
        api.nvim_create_autocmd('TermClose', {
            buffer = data.buf,
            once = true,
            callback = function()
                safe_close_win(data.win)
                data.win = nil
            end,
        })
    end

    M._open_window(data.buf, pos, id)
end

-- Hide all terminal buffers from buffer list
vim.api.nvim_create_autocmd('TermOpen', {
    group = vim.api.nvim_create_augroup('term', { clear = true }),
    pattern = '*',
    callback = function(ctx)
        vim.api.nvim_set_option_value('buflisted', false, { buf = ctx.buf })
        vim.api.nvim_set_option_value('bufhidden', 'hide', { buf = ctx.buf })
    end,
})

return M
