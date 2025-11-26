local transparent_groups = {
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

-- Backgrounds
for _, group in ipairs(transparent_groups) do
    vim.api.nvim_set_hl(0, group, { bg = 'NONE' })
end

-- Foregrounds
vim.api.nvim_set_hl(0, 'LineNr', { fg = '#555555' })
vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = '#e0e0e0', bold = true })
vim.api.nvim_set_hl(0, 'WinSeparator', { fg = '#303030' })
vim.api.nvim_set_hl(0, 'MiniIndentscopeSymbol', { fg = '#2E3440' })
vim.api.nvim_set_hl(0, 'ModeMsg', { fg = '#d19a66' })

if vim.g.colors_name == 'nord' then
    vim.api.nvim_set_hl(0, '@number', { fg = '#B48EAD' })
    vim.api.nvim_set_hl(0, 'String', { fg = '#D0D0D0' })
    vim.api.nvim_set_hl(0, '@string', { fg = '#E5E9F0' }) -- treesitter
    vim.api.nvim_set_hl(0, '@tag', { fg = '#E5E9F0' })
elseif vim.g.colors_name == 'plain' or 'off' then
    vim.api.nvim_set_hl(0, '@keyword', { fg = '#0d3b66', bold = true })
    vim.api.nvim_set_hl(0, '@number', { fg = '#8B0000' })

    -- vim.api.nvim_set_hl(0, '@jsxText', { fg = '#E5E9F0' })
    -- vim.api.nvim_set_hl(0, '@text.literal', { fg = '#E5E9F0' })

    -- // -- // --
    -- vim.api.nvim_set_hl(0, '@comment', { fg = '#4a4a4a', italic = true })
    -- vim.api.nvim_set_hl(0, '@string', { fg = '#777777' })
    -- vim.api.nvim_set_hl(0, 'String', { fg = '#006400' })
    vim.api.nvim_set_hl(0, 'String', { fg = '#E5E9F0' })
    -- vim.api.nvim_set_hl(0, 'Number', { fg = '#8B0000' })
    -- vim.api.nvim_set_hl(0, '@boolean', { fg = '#E5E9F0' })
end

vim.cmd [[highlight PmenuSel guibg=#4a4a4a ]]
