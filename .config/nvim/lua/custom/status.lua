local ok, harpoon = pcall(require, 'harpoon')

-- Harpoon Statusline
_G.harpoon_statusline = function()
    if not ok then return '' end

    local cur = vim.fn.expand '%:t'
    if cur == '__BufTerm__' then return '' end

    local raw_items = harpoon:list().items or {}
    local items = {}

    -- Filter out invalid / whitespace items
    for _, item in ipairs(raw_items) do
        if item and type(item.value) == "string" and item.value:match("%S") then
            table.insert(items, item)
        end
    end

    if #items == 0 then return '' end

    local fnmod = vim.fn.fnamemodify
    local expand = vim.fn.expand
    local max = math.min(4, #items)

    local parts = {}
    local paths, basenames, counts = {}, {}, {}

    -- Precompute paths, basenames, counts
    for i = 1, max do
        local ok, full = pcall(fnmod, items[i].value, ':p')
        if not ok or full == '' then goto continue end

        local base = fnmod(full, ':t')
        paths[i] = full
        basenames[i] = base
        counts[base] = (counts[base] or 0) + 1

        ::continue::
    end

    -- Build display names
    for i = 1, max do
        local full = paths[i]
        if not full then goto continue end

        local base = basenames[i]
        local disp = (counts[base] > 1) and (fnmod(full, ':h:t') .. '/' .. base) or base

        if full == expand '%:p' then
            parts[#parts + 1] = '%#HarpoonActive#' .. disp .. '%#StatusLine#'
        else
            parts[#parts + 1] = disp
        end

        ::continue::
    end

    return table.concat(parts, ' | ')
end

-- Diagnostics
_G.diagnostics = function()
    local diags = vim.diagnostic.get(0)
    local counts = {0, 0, 0, 0} -- ERROR, WARN, INFO, HINT

    for _, d in ipairs(diags) do
        counts[d.severity] = counts[d.severity] + 1
    end

    local parts = {}
    if counts[1] > 0 then parts[#parts+1] = '%#DiagnosticError# '..counts[1]..'%#StatusLine#' end
    if counts[2] > 0 then parts[#parts+1] = '%#DiagnosticWarn#󰀪 '..counts[2]..'%#StatusLine#' end
    if counts[3] > 0 then parts[#parts+1] = '%#DiagnosticInfo#󰋽 '..counts[3]..'%#StatusLine#' end
    if counts[4] > 0 then parts[#parts+1] = '%#DiagnosticHint#󰌶 '..counts[4]..'%#StatusLine#' end

    return table.concat(parts, ' ')
end

-- Git branch
local function git_branch()
    local head = vim.b.gitsigns_head
    if head and #head > 0 then return head end

    -- fallback if repo but no gitsigns
    local ok, branch = pcall(vim.fn.system, 'git branch --show-current 2>/dev/null')
    if ok then
        branch = branch:gsub('%s+', '')
        if #branch > 0 then return branch end
    end

    return ''
end

-- Main statusline
_G.statusline = function()
    local path = vim.fn.expand '%:p'
    local short = vim.fn.fnamemodify(path, ':p:~:h:t') .. '/' .. vim.fn.expand '%:t'
    if short == '' then short = '[No Name]' end

    local diag = _G.diagnostics()
    local harpoon_list = _G.harpoon_statusline()

    return table.concat {
        '%#StatusLinePath# ',
        short,
        ' ',
        '%#StatusLine#',
        ' %m ',
        diag,
        ' ',
        harpoon_list,
        '%=',
        git_branch(),
        ' %r %h %q',
    }
end

-- Redraw on diagnostic change
vim.api.nvim_create_autocmd({ 'DiagnosticChanged' }, {
    callback = function() vim.cmd.redrawstatus() end,
})

-- Highlight groups
vim.api.nvim_set_hl(0, 'HarpoonActive', { fg = '#0d3b66', bold = true })
vim.api.nvim_set_hl(0, 'StatusLinePath', { bg = '#2E3440', fg = '#e0e0e0' })

-- Activate statusline
vim.o.statusline = '%!v:lua.statusline()'
