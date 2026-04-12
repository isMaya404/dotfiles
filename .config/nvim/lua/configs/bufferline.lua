local MAX_VISIBLE_BUFS = 4

local buffers = {}
local present = {}

local function is_trackable(bufnr)
    return vim.api.nvim_buf_is_valid(bufnr) and vim.bo[bufnr].buflisted and vim.bo[bufnr].buftype == ''
end

local function remove_by_index(idx)
    local bufnr = table.remove(buffers, idx)
    if bufnr then
        present[bufnr] = nil
    end
    -- return bufnr
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

    if #buffers > MAX_VISIBLE_BUFS then
        remove_by_index(1)
    end
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

-- local function bufdel()
--     local current = vim.api.nvim_get_current_buf()
--     if not is_trackable(current) then
--         return
--     end
--
--     local idx = remove_buf(current)
--
--     local target
--     if idx then
--         -- Prefer the next buffer; if current was the last one, fall back to previous.
--         target = buffers[idx] or buffers[idx - 1]
--     end
--
--     if not target then
--         target = vim.fn.bufnr '#'
--     end
--
--     if target and target > 0 and vim.api.nvim_buf_is_valid(target) then
--         vim.api.nvim_set_current_buf(target)
--     end
--
--     pcall(vim.api.nvim_buf_delete, current, { force = false })
-- end
--
-- vim.keymap.set('n', '<leader>x', bufdel, { silent = true, desc = 'Delete current buffer' })

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

--
-- local max_bufferline_tabs = 4
-- local max_buffers = 8
--
-- local visible_buffers = {}
-- local loaded_buffers = {}
--
-- -- Trackable buffer = valid + listed + normal buftype
-- local function is_trackable(bufnr)
--     return vim.api.nvim_buf_is_valid(bufnr) and vim.bo[bufnr].buflisted and vim.bo[bufnr].buftype == ''
-- end
--
-- -- Remove buffer from list if present
-- local function remove_from_list(list, bufnr)
--     for i = #list, 1, -1 do
--         if list[i] == bufnr then
--             table.remove(list, i)
--             return
--         end
--     end
-- end
--
-- -- Clean up dead buffers
-- local function cleanup_invalid(list)
--     for i = #list, 1, -1 do
--         if not vim.api.nvim_buf_is_valid(list[i]) then
--             table.remove(list, i)
--         end
--     end
-- end
--
-- -- Track a buffer (called on BufEnter)
-- local function track_buffer(bufnr)
--     if not is_trackable(bufnr) then
--         return
--     end
--
--     cleanup_invalid(visible_buffers)
--     cleanup_invalid(loaded_buffers)
--
--     remove_from_list(visible_buffers, bufnr)
--     remove_from_list(loaded_buffers, bufnr)
--
--     table.insert(visible_buffers, 1, bufnr)
--     table.insert(loaded_buffers, 1, bufnr)
--
--     -- Trim visible tab list
--     if #visible_buffers > max_bufferline_tabs then
--         table.remove(visible_buffers)
--     end
--
--     -- Trim total buffers if over cap
--     if #loaded_buffers > max_buffers then
--         local to_remove = table.remove(loaded_buffers)
--         if is_trackable(to_remove) and not vim.bo[to_remove].modified then
--             vim.cmd('silent! bd ' .. to_remove)
--         end
--     end
-- end
--
-- -- Init visible_buffers with existing valid buffers on startup
-- for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
--     if is_trackable(bufnr) then
--         table.insert(visible_buffers, bufnr)
--         if #visible_buffers >= max_bufferline_tabs then
--             break
--         end
--     end
-- end
--
-- -- Autocmd for runtime tracking
-- vim.api.nvim_create_autocmd('BufEnter', {
--     callback = function(args)
--         track_buffer(args.buf)
--     end,
-- })
--
-- -- Bufferline setup
-- require('bufferline').setup {
--     options = {
--         mode = 'buffers',
--         numbers = 'none',
--         diagnostics = 'nvim_lsp',
--         hover = { enabled = false },
--         show_close_icon = false,
--         show_buffer_close_icons = false,
--         separator_style = 'thin',
--         always_show_bufferline = true,
--         custom_filter = function(bufnr)
--             if not vim.api.nvim_buf_is_valid(bufnr) then
--                 return false
--             end
--             for _, b in ipairs(visible_buffers) do
--                 if b == bufnr then
--                     return true
--                 end
--             end
--             return false
--         end,
--         offsets = {
--             {
--                 filetype = 'NvimTree',
--                 text = '',
--                 highlight = 'Directory',
--                 text_align = 'left',
--             },
--         },
--     },
-- }
