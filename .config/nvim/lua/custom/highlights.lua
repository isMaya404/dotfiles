local transparent_bg_group = {
    'Normal',
    'NormalNC',
    'NormalFloat',
    'FloatBorder',
    'Pmenu',
    'TelescopeNormal',
    'TelescopeBorder',
    'SignColumn',
    'StatusLine',
    'TabLine',
    'TabLineFill',
    'TabLineSel',
    'WinSeparator',
    'CursorLine',
}

local set_hl = vim.api.nvim_set_hl

-- Backgrounds
for _, group in ipairs(transparent_bg_group) do
    set_hl(0, group, { bg = 'NONE' })
end

set_hl(0, 'LineNr', { fg = '#555555' })
set_hl(0, 'CursorLineNr', { fg = '#e0e0e0', bold = true })
set_hl(0, 'WinSeparator', { fg = '#303030' })
set_hl(0, 'FloatBorder', { fg = '#3b4252' })
set_hl(0, 'ModeMsg', { fg = '#d19a66' })
set_hl(0, 'MiniIndentscopeSymbol', { fg = '#2E3440' })

-- BlinkCmpMenuBorder xxx guifg=

if vim.g.colors_name == 'nord' then
    -- set_hl(0, '@number', { fg = '#B48EAD' })
    set_hl(0, '@number', { fg = '#8B0000' })
    set_hl(0, 'String', { fg = '#D0D0D0' })
    set_hl(0, '@string', { fg = '#E5E9F0' }) -- treesitter
    set_hl(0, '@tag', { fg = '#E5E9F0' })
end
