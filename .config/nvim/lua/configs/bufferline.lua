local max_bufferline_tabs = 3
local max_buffers = 8

local visible_buffers = {}
local loaded_buffers = {}

-- Trackable buffer = valid + listed + normal buftype
local function is_trackable(bufnr)
    return vim.api.nvim_buf_is_valid(bufnr) and vim.bo[bufnr].buflisted and vim.bo[bufnr].buftype == ''
end

-- Remove buffer from list if present
local function remove_from_list(list, bufnr)
    for i = #list, 1, -1 do
        if list[i] == bufnr then
            table.remove(list, i)
            return
        end
    end
end

-- Clean up dead buffers
local function cleanup_invalid(list)
    for i = #list, 1, -1 do
        if not vim.api.nvim_buf_is_valid(list[i]) then
            table.remove(list, i)
        end
    end
end

-- Track a buffer (called on BufEnter)
local function track_buffer(bufnr)
    if not is_trackable(bufnr) then
        return
    end

    cleanup_invalid(visible_buffers)
    cleanup_invalid(loaded_buffers)

    remove_from_list(visible_buffers, bufnr)
    remove_from_list(loaded_buffers, bufnr)

    table.insert(visible_buffers, 1, bufnr)
    table.insert(loaded_buffers, 1, bufnr)

    -- Trim visible tab list
    if #visible_buffers > max_bufferline_tabs then
        table.remove(visible_buffers)
    end

    -- Trim total buffers if over cap
    if #loaded_buffers > max_buffers then
        local to_remove = table.remove(loaded_buffers)
        if is_trackable(to_remove) and not vim.bo[to_remove].modified then
            vim.cmd('silent! bd ' .. to_remove)
        end
    end
end

-- Init visible_buffers with existing valid buffers on startup
for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if is_trackable(bufnr) then
        table.insert(visible_buffers, bufnr)
        if #visible_buffers >= max_bufferline_tabs then
            break
        end
    end
end

-- Autocmd for runtime tracking
vim.api.nvim_create_autocmd('BufEnter', {
    callback = function(args)
        track_buffer(args.buf)
    end,
})

-- Bufferline setup
require('bufferline').setup {
    options = {
        mode = 'buffers',
        numbers = 'none',
        diagnostics = 'nvim_lsp',
        hover = { enabled = false },
        show_close_icon = false,
        show_buffer_close_icons = false,
        separator_style = 'thin',
        always_show_bufferline = true,
        custom_filter = function(bufnr)
            if not vim.api.nvim_buf_is_valid(bufnr) then
                return false
            end
            for _, b in ipairs(visible_buffers) do
                if b == bufnr then
                    return true
                end
            end
            return false
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

-- Tab-like keymaps (visible buffer index)
vim.keymap.set('n', '<leader>1', '<Cmd>BufferLineGoToBuffer 1<CR>')
vim.keymap.set('n', '<leader>2', '<Cmd>BufferLineGoToBuffer 2<CR>')
vim.keymap.set('n', '<leader>3', '<Cmd>BufferLineGoToBuffer 3<CR>')
vim.keymap.set('n', '<leader>4', '<Cmd>BufferLineGoToBuffer 4<CR>')
