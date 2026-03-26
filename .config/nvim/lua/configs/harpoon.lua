local harpoon = require 'harpoon'

harpoon:setup {
    settings = {
        save_on_toggle = true,
        save_on_change = true,
        mark_branch = true,
        excluded_filetypes = { 'harpoon' },
    },
}

-- map('n', '<leader>r', function()
--     local list = require('harpoon'):list()
--     local items = list.items
--     for i = 1, math.floor(#items / 2) do
--         items[i], items[#items - i + 1] = items[#items - i + 1], items[i]
--     end
--     refresh_statusline_harpoon_list_cache()
-- end, { desc = 'Harpoon [R]everse List' })

local map = vim.keymap.set

map('n', '<leader>.', function()
    harpoon:list():add()
    vim.cmd 'doautocmd User HarpoonUpdated'
end)

map('n', '<leader>h', function()
    harpoon.ui:toggle_quick_menu(harpoon:list())
end)

map('n', '<leader>j', function()
    harpoon:list():select(1)
    vim.cmd 'doautocmd User HarpoonUpdated'
end, { desc = 'Harpoon: Jump to file 1' })

map('n', '<leader>k', function()
    harpoon:list():select(2)
    vim.cmd 'doautocmd User HarpoonUpdated'
end, { desc = 'Harpoon: Jump to file 2' })

map('n', '<leader>l', function()
    harpoon:list():select(3)
    vim.cmd 'doautocmd User HarpoonUpdated'
end, { desc = 'Harpoon: Jump to file 3' })

map('n', '<leader>p', function()
    harpoon:list():select(4)
    vim.cmd 'doautocmd User HarpoonUpdated'
end, { desc = 'Harpoon: Jump to file 4' })

map('n', "<leader>'", function()
    harpoon:list():select(5)
    vim.cmd 'doautocmd User HarpoonUpdated'
end, { desc = 'Harpoon: Jump to file 5' })
