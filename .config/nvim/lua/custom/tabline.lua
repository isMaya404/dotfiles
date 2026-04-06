vim.cmd 'highlight! TabLineFill            guibg=NONE guifg=#c0c0c0'
vim.cmd 'highlight! TabLineTabInactive     guibg=NONE guifg=#c0c0c0'
vim.cmd 'highlight! TabLineTabActive       guibg=NONE guifg=#d19a66'

local INITIAL_OFFSET = 6

vim.o.showtabline = 1 -- Only show tabline if there are at least two tab pages (2 always shows it)
vim.o.tabline = '%!v:lua.CustomTabline()'

_G.CustomTabline = function()
    local tree_width = 0

    for _, w in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        local buf = vim.api.nvim_win_get_buf(w)
        if vim.bo[buf].filetype == 'NvimTree' then
            tree_width = vim.api.nvim_win_get_width(w)
            break
        end
    end

    local parts = {}

    local pad = tree_width + INITIAL_OFFSET

    if pad > 0 then
        parts[#parts + 1] = string.rep(' ', pad)
    end

    local cur_tab = vim.fn.tabpagenr()
    local tab_count = vim.fn.tabpagenr '$'
    for i = 1, tab_count do
        local hl_tab = (i == cur_tab) and '%#TabLineTabActive#' or '%#TabLineTabInactive#'
        parts[#parts + 1] = hl_tab .. tostring(i) .. '  '
    end

    parts[#parts + 1] = '%#TabLineFill#%='
    return table.concat(parts)
end
