local diagnostic_cache = ''

-- DIAGNOSTICS
local function handle_diagnostic_list()
    local diagnostics = vim.diagnostic.get(0)
    local counts = { 0, 0, 0, 0 }

    for _, d in ipairs(diagnostics) do
        counts[d.severity] = counts[d.severity] + 1
    end

    local parts = {}
    if counts[1] > 0 then
        parts[#parts + 1] = '%#DiagnosticError# ' .. counts[1] .. '%#StatusLine#'
    end
    if counts[2] > 0 then
        parts[#parts + 1] = '%#DiagnosticWarn#󰀪 ' .. counts[2] .. '%#StatusLine#'
    end
    if counts[3] > 0 then
        parts[#parts + 1] = '%#DiagnosticInfo#󰋽 ' .. counts[3] .. '%#StatusLine#'
    end
    if counts[4] > 0 then
        parts[#parts + 1] = '%#DiagnosticHint#󰌶 ' .. counts[4] .. '%#StatusLine#'
    end

    diagnostic_cache = table.concat(parts, ' ')
end

-- HARPOON
local harpoon_ok, harpoon = pcall(require, 'harpoon')

local harpoon_list_cache = ''

local function basename(path)
    return path:match '([^/\\]+)$' or path
end

local uv = vim.uv or vim.loop

local function normalize(path)
    if not path or path == '' then
        return ''
    end
    return uv.fs_realpath(path) or vim.fs.normalize(path)
end

_G.handle_harpoon_list = function()
    if not harpoon_ok or not harpoon then
        harpoon_list_cache = ''
        return
    end

    local list = harpoon:list()
    local items = (list and list.items) or {}
    local current = normalize(vim.api.nvim_buf_get_name(0))
    local max = math.min(5, #items)

    local parts = {}
    for i = 1, max do
        local value = items[i] and items[i].value
        if type(value) == 'string' and value ~= '' then
            local full = normalize(value)
            local base = basename(full)
            local disp = (#base > 20) and (base:sub(1, 20) .. '…') or base

            -- prepend number
            disp = i .. ':' .. disp

            if full == current then
                disp = '%#HarpoonActive#' .. disp .. '%#StatusLine#'
            end

            parts[#parts + 1] = disp
        end
    end

    harpoon_list_cache = table.concat(parts, ' | ')
end

-- GIT
local function git_branch()
    return vim.b.gitsigns_head or ''
end

-- STATUSLINE
_G.statusline = function()
    return table.concat {
        '%#StatusLinePath# %<%t ',
        '%#StatusLine#',
        ' %m ',
        diagnostic_cache,
        ' ',
        harpoon_list_cache,
        '%=',
        git_branch(),
        ' %y %r %h %q',
    }
end

-- Autocmds
vim.api.nvim_create_autocmd('BufEnter', {
    callback = function()
        _G.handle_harpoon_list()
    end,
})

vim.api.nvim_create_autocmd({ 'DiagnosticChanged', 'BufEnter' }, {
    callback = function()
        handle_diagnostic_list()
    end,
})

-- Triggered with harpoon bindings or when leaving the harpoon menu buffer
vim.api.nvim_create_augroup('HarpoonStatus', { clear = true })
vim.api.nvim_create_autocmd({ 'BufWinLeave', 'User' }, {
    pattern = { '__harpoon-menu__*', 'HarpoonUpdated' },
    group = 'HarpoonStatus',
    callback = function()
        _G.handle_harpoon_list()
        vim.cmd.redrawstatus()
    end,
})

-- Highlights
vim.api.nvim_set_hl(0, 'HarpoonActive', { fg = '#0d3b66', bold = true })
vim.api.nvim_set_hl(0, 'StatusLinePath', { bg = '#2E3440', fg = '#e0e0e0' })

-- Activate Statusline
vim.o.statusline = '%!v:lua.statusline()'
