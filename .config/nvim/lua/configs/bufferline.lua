local MAX_BUFFERS = 4

-- Oldest -> newest
local buffers = {}
local present = {} -- O(1) membership, no scanning

local function is_trackable(bufnr)
    return vim.api.nvim_buf_is_valid(bufnr) and vim.bo[bufnr].buflisted and vim.bo[bufnr].buftype == ''
end

local function remove_by_index(idx)
    local bufnr = table.remove(buffers, idx)
    if bufnr then
        present[bufnr] = nil
    end
    return bufnr
end

local function remove_buf(bufnr)
    if not present[bufnr] then
        return nil
    end

    present[bufnr] = nil

    for i = 1, #buffers do
        if buffers[i] == bufnr then
            table.remove(buffers, i)
            return i
        end
    end

    return nil
end

local function track_buffer(bufnr)
    if not is_trackable(bufnr) or present[bufnr] then
        return
    end

    present[bufnr] = true
    buffers[#buffers + 1] = bufnr

    if #buffers > MAX_BUFFERS then
        local oldest = remove_by_index(1)

        -- Hard cap. If you want absolutely strict eviction, change force = false to true.
        if oldest and oldest ~= vim.api.nvim_get_current_buf() and vim.api.nvim_buf_is_valid(oldest) and not vim.bo[oldest].modified then
            vim.schedule(function()
                if vim.api.nvim_buf_is_valid(oldest) then
                    pcall(vim.api.nvim_buf_delete, oldest, { force = false })
                end
            end)
        end
    end
end

local function smart_bufdel()
    local current = vim.api.nvim_get_current_buf()
    if not is_trackable(current) then
        return
    end

    local idx = remove_buf(current)

    local target
    if idx then
        -- Prefer the next buffer; if current was the last one, fall back to previous.
        target = buffers[idx] or buffers[idx - 1]
    end

    if not target then
        target = vim.fn.bufnr '#'
    end

    if target and target > 0 and vim.api.nvim_buf_is_valid(target) then
        vim.api.nvim_set_current_buf(target)
    end

    pcall(vim.api.nvim_buf_delete, current, { force = false })
end

vim.api.nvim_create_autocmd('BufEnter', {
    callback = function(args)
        track_buffer(args.buf)
    end,
})

vim.api.nvim_create_autocmd('BufWipeout', {
    callback = function(args)
        remove_buf(args.buf)
    end,
})

vim.keymap.set('n', '<leader>bd', smart_bufdel, { silent = true, desc = 'Delete buffer and keep focus' })

require('bufferline').setup {
    options = {
        mode = 'buffers',
        numbers = 'ordinal',
        diagnostics = 'nvim_lsp',
        hover = { enabled = false },
        show_close_icon = false,
        show_buffer_close_icons = false,
        separator_style = 'thin',
        always_show_bufferline = true,
        custom_filter = function(bufnr)
            return present[bufnr] == true
        end,
        offsets = {
            {
                filetype = 'NvimTree',
                text = '',
                highlight = 'Directory',
                text_align = 'left',
            },
        },
    },
}
