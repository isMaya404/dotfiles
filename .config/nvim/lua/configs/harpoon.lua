local map = vim.keymap.set
local harpoon = require 'harpoon'

harpoon:setup {
    settings = {
        save_on_toggle = true,
        save_on_change = true,
        mark_branch = true,
        excluded_filetypes = { 'harpoon' },
    },
}

-- reverse harpoon list
map('n', '<leader>r', function()
    local list = require('harpoon'):list()
    local items = list.items
    for i = 1, math.floor(#items / 2) do
        items[i], items[#items - i + 1] = items[#items - i + 1], items[i]
    end
    vim.cmd.redrawstatus() -- refresh list on status to reflect changes
end, { desc = 'Harpoon [R]everse List' })

map('n', '<leader>.', function()
    require('harpoon'):list():add()
    vim.cmd.redrawstatus() -- refresh list on status to reflect changes
end)

map('n', '<leader>h', function()
    harpoon.ui:toggle_quick_menu(harpoon:list())
end)

map('n', '<leader>j', function()
    harpoon:list():select(1)
end, { desc = 'Harpoon: Jump to file 1' })

map('n', '<leader>k', function()
    harpoon:list():select(2)
end, { desc = 'Harpoon: Jump to file 2' })

map('n', '<leader>l', function()
    harpoon:list():select(3)
end, { desc = 'Harpoon: Jump to file 3' })

map('n', '<leader>p', function()
    harpoon:list():select(4)
end, { desc = 'Harpoon: Jump to file 4' })
