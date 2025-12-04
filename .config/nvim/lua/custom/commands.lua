vim.api.nvim_create_user_command('Gl', function()
    vim.cmd 'Gclog'
end, {})

vim.api.nvim_create_user_command('Gcm', function()
    vim.cmd 'G commit -m'
end, {})

vim.api.nvim_create_user_command('Gp', function()
    vim.cmd 'G push'
end, {})

vim.api.nvim_create_user_command('Gpf', function()
    vim.cmd 'G push --force-with-lease'
end, {})
