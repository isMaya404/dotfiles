local function augroup(name)
    return vim.api.nvim_create_augroup('idk_' .. name, { clear = true })
end

-- LSP file renaming integration for nvim-tree
local Snacks = require 'snacks'
local prev = { new_name = '', old_name = '' } -- prevents duplicate events
vim.api.nvim_create_autocmd('User', {
    pattern = 'NvimTreeSetup',
    callback = function()
        local events = require('nvim-tree.api').events
        events.subscribe(events.Event.NodeRenamed, function(data)
            if prev.new_name ~= data.new_name or prev.old_name ~= data.old_name then
                data = data
                Snacks.rename.on_rename_file(data.old_name, data.new_name)
            end
        end)
    end,
})

-- LSP file renaming integration for oil.nvim
vim.api.nvim_create_autocmd('User', {
    pattern = 'OilActionsPost',
    callback = function(event)
        if event.data.actions[1].type == 'move' then
            Snacks.rename.on_rename_file(event.data.actions[1].src_url, event.data.actions[1].dest_url)
        end
    end,
})

-- Useful with nvimlsp-config event trigger and other plugins that behave similarly
-- https://github.com/NvChad/NvChad/blob/v2.5/lua/nvchad/autocmds.lua
vim.api.nvim_create_autocmd({ 'UIEnter', 'BufReadPost', 'BufNewFile' }, {
    group = vim.api.nvim_create_augroup('FilePostEvent', { clear = true }),
    callback = function(args)
        local file = vim.api.nvim_buf_get_name(args.buf)
        local buftype = vim.api.nvim_get_option_value('buftype', { buf = args.buf })

        if not vim.g.ui_entered and args.event == 'UIEnter' then
            vim.g.ui_entered = true
        end

        if file ~= '' and buftype ~= 'nofile' and vim.g.ui_entered then
            vim.api.nvim_exec_autocmds('User', { pattern = 'FilePost', modeline = false })
            vim.api.nvim_del_augroup_by_name 'FilePostEvent'

            vim.schedule(function()
                vim.api.nvim_exec_autocmds('FileType', {})

                -- if vim.g.editorconfig then
                --     require('editorconfig').config(args.buf)
                -- end
            end)
        end
    end,
})

--  highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
    group = augroup 'highlight_yank',
    callback = function()
        (vim.hl or vim.highlight).on_yank()
    end,
})

------------------- Buffers -------------------

-- Hide terminal buffers from buffer list
vim.api.nvim_create_autocmd('TermOpen', {
    group = augroup 'term',
    pattern = '*',
    callback = function(ctx)
        vim.api.nvim_set_option_value('buflisted', false, { buf = ctx.buf })
        vim.api.nvim_set_option_value('bufhidden', 'hide', { buf = ctx.buf })
    end,
})

-- restore last cursor position (except commits & only once)
vim.api.nvim_create_autocmd('BufReadPost', {
    group = augroup 'last_loc',
    callback = function(ctx)
        local buf = ctx.buf
        local ft = vim.bo[buf].filetype
        if ft == 'gitcommit' or vim.b[buf].cursor_last_loc then
            return
        end
        vim.b[buf].cursor_last_loc = true
        local mark = vim.api.nvim_buf_get_mark(buf, '"')
        local lines = vim.api.nvim_buf_line_count(buf)
        if mark[1] > 0 and mark[1] <= lines then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
})

-- remove format options r and o
-- r auto-continue comments on Enter
-- o auto-continue comments on o/O
vim.api.nvim_create_autocmd({ 'FileType' }, {
    group = augroup 'format_options',
    pattern = { '*' },
    callback = function()
        vim.opt_local.fo:remove 'o'
        vim.opt_local.fo:remove 'r'
    end,
})

-- max N bufs, auto-delete oldest buf if more than N.
-- this is to prevent auto-session from restoring too many bufs
local MAX = 20
local buffers = {}
local present = {}

local function track_bufs(bufnr)
    if not vim.bo[bufnr].buflisted or vim.bo[bufnr].buftype ~= '' then
        return
    end

    if present[bufnr] then
        -- move to end
        for i, b in ipairs(buffers) do
            if b == bufnr then
                table.remove(buffers, i)
                break
            end
        end
    end

    present[bufnr] = true
    table.insert(buffers, bufnr)

    if #buffers > MAX then
        local oldest = table.remove(buffers, 1)
        present[oldest] = nil

        if oldest ~= vim.api.nvim_get_current_buf() then
            pcall(vim.api.nvim_buf_delete, oldest, { force = true })
        end
    end
end

vim.api.nvim_create_autocmd('BufEnter', {
    callback = function(args)
        track_bufs(args.buf)
    end,
})

------------------- Comments -------------------

-- treat certain files that does not use strict JSON as jsonc to allow commenting
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
    pattern = {
        '.prettierrc',
        'tsconfig.json',
        '.eslintrc.json',
        -- other ft's
    },
    callback = function()
        vim.bo.filetype = 'jsonc'
        vim.bo.commentstring = '// %s'
    end,
})

--  commentstring support
local commentstrings = {
    apache = '# %s',
    -- other ft's
}
vim.api.nvim_create_autocmd('FileType', {
    group = augroup 'commentstring',
    pattern = vim.tbl_keys(commentstrings),
    callback = function(ctx)
        vim.bo[ctx.buf].commentstring = commentstrings[ctx.match]
    end,
})

----------------- / -------------------

-- treat certain template ft's as HTML for syntax highlighting support
-- vim.api.nvim_create_autocmd('BufEnter', {
--     group = augroup 'template_html',
--     pattern = { '*.ejs' },
--     callback = function()
--         vim.opt_local.filetype = 'html'
--     end,
-- })

-- apply remaps on man pages (this is just to match my nvim remaps)
vim.api.nvim_create_autocmd('FileType', {
    group = augroup 'man_remap',
    pattern = 'man',
    callback = function()
        local opts = { buffer = true, silent = true, noremap = true }
        local map = vim.keymap.set

        map({ 'n', 'x', 'o' }, 'j', 'h', opts)
        map({ 'n', 'x', 'o' }, 'p', 'l', opts)

        map({ 'o' }, 'k', 'j', opts)
        map({ 'o' }, 'l', 'k', opts)
        map({ 'n', 'x' }, 'k', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
        map({ 'n', 'x' }, 'l', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

        map({ 'n', 'x', 'o' }, 'h', 'p', opts)
        map({ 'n', 'x', 'o' }, 'H', 'P', opts)

        map({ 'n', 'v', 'x', 'o' }, 'J', 'H', opts)
        map('n', 'K', function()
            vim.lsp.buf.hover { border = 'rounded' }
        end)
        map({ 'n', 'x' }, 'L', 'M', opts)
        map({ 'n', 'x', 'o' }, 'P', 'L', opts)

        map({ 'n', 'x', 'o' }, 'b', 'nzzzv', opts)
        map({ 'n', 'x', 'o' }, 'B', 'Nzzzv', opts)
        map({ 'n', 'x', 'o' }, 'n', 'b', opts)
        map({ 'n', 'x', 'o' }, 'N', 'B', opts)

        map({ 'n', 'x', 'o' }, 'o', 'y', opts)
        map({ 'n', 'x', 'o' }, 'O', 'y$', opts)
        map({ 'n', 'x', 'o' }, 'm', 'o', opts)
        map({ 'n', 'x', 'o' }, 'M', 'O', opts)
        map({ 'n', 'x', 'o' }, 'y', 'm', opts)
        map({ 'n', 'x', 'o' }, 'Y', 'J', opts)
    end,
})
