local cmd = vim.api.nvim_create_user_command

cmd('Gl', function()
    vim.cmd 'Gclog'
end, {})

cmd('Gcm', function()
    vim.cmd 'G commit -m'
end, {})

cmd('Gp', function()
    vim.cmd 'G push'
end, {})

cmd('Gpf', function()
    vim.cmd 'G push --force-with-lease'
end, {})
