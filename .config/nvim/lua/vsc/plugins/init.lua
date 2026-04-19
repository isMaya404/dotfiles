return {

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
                    -- normal_line = 'OS',
                    -- normal_cur_line = 'OSS',
                },
            }
        end,
        --     surr*ound_words             osiw)           (surround_words)
        --     'change quot*es'            cs'"            "change quotes"
        --     [delete ar*ound me!]        ds[             delete around me!
        --     *make strings               os$"            "make strings"
        --     remove <h1>HTML t*ags</h1>    dst             remove HTML tags
        --     <h1>or tag* types</h1>        csth1<CR>       <h1>or tag types</h1>

        -- :h nvim-surround.usage
    },

}
