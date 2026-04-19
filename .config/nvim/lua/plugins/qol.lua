return {
    -- goated
    { 'shortcuts/no-neck-pain.nvim', version = '*', cmd = 'NoNeckPain' },

    {
        'saghen/blink.cmp',
        event = 'InsertEnter',
        version = '1.*',
        build = vim.g.lazyvim_blink_main and 'cargo build --release',
        config = function()
            require 'configs.blink'
        end,
    },

    -- {
    --     'hrsh7th/nvim-cmp',
    --     event = 'InsertEnter',
    --     dependencies = {
    --         'hrsh7th/cmp-nvim-lsp',
    --         'hrsh7th/cmp-buffer',
    --         'hrsh7th/cmp-path',
    --         'hrsh7th/cmp-nvim-lua',
    --         'hrsh7th/cmp-cmdline',
    --         'onsails/lspkind.nvim',
    --         'saadparwaiz1/cmp_luasnip',
    --         'brenoprata10/nvim-highlight-colors',
    --         ,
    --     },
    --     opts = require('configs.cmp').opts,
    --     config = require('configs.cmp').config,
    -- },

    {
        'neovim/nvim-lspconfig',
        event = 'User FilePost',
        -- event = 'VeryLazy',
        dependencies = {
            'williamboman/mason.nvim',
            'WhoIsSethDaniel/mason-tool-installer.nvim',
            'j-hui/fidget.nvim',
        },
        config = function()
            require 'configs.lsp._lsp'
        end,
    },

    -- makes file ops lsp-aware. It notifies
    -- the lsp so imports and references update automatically.
    {
        'antosha417/nvim-lsp-file-operations',
        event = 'VeryLazy',
        config = function()
            require('lsp-file-operations').setup()
        end,
    },

    -- {
    --     'folke/snacks.nvim',
    --     event = 'VeryLazy',
    --     opts = {
    --         rename = {
    --             enabled = true,
    --         },
    --     },
    -- },

    -- smarter folding
    {
        'kevinhwang91/nvim-ufo',
        dependencies = 'kevinhwang91/promise-async',
        event = 'VeryLazy',
        -- event = 'BufReadPost',
        opts = function()
            return require 'configs.nvim_ufo'
        end,
    },

    -- multi cursor
    {
        'mg979/vim-visual-multi',
        branch = 'master',
        event = 'VeryLazy',
        -- init instead of config for remaps to work
        -- See https://github.com/mg979/vim-visual-multi/issues/241
        init = function()
            require 'configs.visual_multi'
        end,
    },

    -- view images in neovim (term emu has to have support for image rendering)
    {
        '3rd/image.nvim',
        event = 'VeryLazy',
        commit = '4206c48',
        config = function()
            require 'configs.image_nvim.image'
            -- require 'configs.image_nvim.luarocks' -- deps
        end,
    },
}
