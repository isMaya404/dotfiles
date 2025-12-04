return {
    {
        'ThePrimeagen/harpoon',
        event = 'VeryLazy',
        branch = 'harpoon2',
        config = function()
            require 'configs.harpoon'
        end,
    },
    {
        'kylechui/nvim-surround',
        version = '^3.0.0',
        event = 'VeryLazy',
        config = function()
            -- require 'configs.nvim_surround'
            require('nvim-surround').setup {
                keymaps = {
                    normal = 'os',
                    normal_cur = 'oss',
                    normal_line = 'oS',
                    normal_cur_line = 'oSS',
                },
            }
        end,
    },
}
