return {
    { 'nvim-lua/plenary.nvim', event = 'VeryLazy' },

    -- colorscheme
    {
        'gbprod/nord.nvim',
        lazy = false,
        priority = 1000,
        config = function()
            require('nord').setup {
                transparent = false,
            }
            vim.cmd.colorscheme 'nord'
        end,
    },
    install = {
        colorscheme = { 'nord' },
    },
    -- {
    --     'folke/tokyonight.nvim',
    --     lazy = false,
    --     priority = 1000,
    --     opts = {},
    --     config = function()
    --         vim.cmd [[colorscheme tokyonight-moon]]
    --     end,
    -- },

    -- {
    --     -- 'andreypopp/vim-colors-plain',
    --     'pbrisbin/vim-colors-off',
    --     lazy = false,
    --     priority = 1000,
    --     init = function()
    --         vim.cmd [[colorscheme off]]
    --         -- vim.cmd [[colorscheme plain]]
    --         vim.o.background = 'dark'
    --     end,
    -- },

    -- session manaager
    {
        'rmagatti/auto-session',
        event = 'VimEnter',
        config = function()
            require 'configs.auto_session'
        end,
    },

    {
        'tpope/vim-sleuth',
        event = 'VeryLazy',
    },

    -- auto pair paren, brackets, quotes, etc.
    {
        'windwp/nvim-autopairs',
        event = 'VeryLazy',
        opts = {
            fast_wrap = {},
            disable_filetype = { 'TelescopePrompt', 'vim' },
        },
        config = function(_, opts)
            require('nvim-autopairs').setup(opts)
            -- require('nvim-autopairs').enable_cmdline()
        end,
    },

    -- git integrations

    {
        'tpope/vim-fugitive',
        event = 'VeryLazy',
    },

    {
        'sindrets/diffview.nvim',
        config = function()
            require 'configs.diffview'
        end,
    },

    -- {
    --     'esmuellert/vscode-diff.nvim',
    --     dependencies = { 'MunifTanjim/nui.nvim' },
    -- },

    {
        'lewis6991/gitsigns.nvim',
        event = 'BufReadPost',
        config = function()
            require 'configs.gitsigns'
        end,
    },

    -- file trees
    {
        'stevearc/oil.nvim',
        ---@module 'oil'
        ---@type oil.SetupOpts
        opts = {},
        -- Optional dependencies
        event = 'VeryLazy',
        lazy = true,
    },

    {
        'nvim-tree/nvim-tree.lua',
        cmd = { 'NvimTreeToggle', 'NvimTreeFocus' },
        config = function()
            require 'configs.nvim_tree'
        end,
    },

    -- blazingly fast???
    {
        'ThePrimeagen/harpoon',
        event = 'VeryLazy',
        branch = 'harpoon2',
        config = function()
            require 'configs.harpoon'
        end,
    },

    -- { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },

    -- no more annoyinng default notif
    {
        'rcarriga/nvim-notify',
        event = 'VeryLazy',
        opts = {
            background_colour = '#000000',
            timeout = 3000, -- ms
            max_width = 65,
            stages = 'static',
            render = 'default',
            top_down = false,
        },
        config = function(_, opts)
            require('notify').setup(opts)

            -- override vim.notify
            vim.notify = require 'notify'
        end,
    },

    -- file picker
    {
        'nvim-telescope/telescope.nvim',
        cmd = 'Telescope',
        dependencies = {
            {
                'nvim-telescope/telescope-fzf-native.nvim',
                build = 'make',
                cond = function()
                    return vim.fn.executable 'make' == 1
                end,
            },
            { 'nvim-telescope/telescope-ui-select.nvim' },
        },
        config = function()
            require 'configs.telescope'
        end,
    },

    -- keymap management
    {
        'folke/which-key.nvim',
        event = 'VeryLazy',
        config = function()
            require 'configs.which_key'
        end,
    },

    -- better comments
    {
        'folke/todo-comments.nvim',
        event = 'VeryLazy',
        opts = {
            signs = false,
            keywords = {
                FIX = {
                    icon = ' ',
                    color = 'error',
                    alt = { 'FIXME', 'BUG', 'FIXIT', 'ISSUE' },
                    -- signs = false, -- configure signs for some keywords individually
                },
                TODO = { icon = ' ', color = 'info' },
                HACK = { icon = ' ', color = 'warning' },
                WARN = { icon = ' ', color = 'warning', alt = { 'WARNING', 'XXX' } },
                PERF = { icon = ' ', alt = { 'OPTIM', 'PERFORMANCE', 'OPTIMIZE' } },
                NOTE = { icon = ' ', color = 'hint', alt = { 'INFO' } },
                TEST = { icon = '⏲ ', color = 'test', alt = { 'TESTING', 'PASSED', 'FAILED' } },
            },
        },
    },

    -- syntax highlighting, motions, folding, text objects, etc.
    {
        'nvim-treesitter/nvim-treesitter',
        event = { 'BufReadPost', 'BufNewFile' },
        cmd = { 'TSInstall', 'TSBufEnable', 'TSBufDisable', 'TSModuleInfo' },
        build = ':TSUpdate',
        main = 'nvim-treesitter.configs', -- sets main module to use for opts
        config = function()
            require 'configs.tree_sitter'
        end,
        -- opts = {},
    },

    -- linter
    -- {
    --     'nvimtools/none-ls.nvim',
    --     dependencies = {
    --         'nvimtools/none-ls-extras.nvim',
    --     },
    --     event = 'VeryLazy',
    --     opts = function()
    --         return require 'configs.none_ls'
    --     end,
    -- },

    -- formatter
    {
        'stevearc/conform.nvim',
        event = 'BufWritePre',
        config = function()
            require 'configs.conform'
        end,
    },

    -- snippet engine
    {
        'L3MON4D3/LuaSnip',
        dependencies = { 'rafamadriz/friendly-snippets' }, -- snippet collections from vscode
        verion = 'v2.*',
        build = 'make install_jsregexp',
        event = 'VeryLazy',
        config = function()
            require('luasnip.loaders.from_vscode').lazy_load()
            require('luasnip.loaders.from_lua').load {
                paths = { vim.fn.stdpath 'config' .. '/lua/snippets' },
            }
        end,
    },

    -- snippets lookup with telescope
    {
        'benfowler/telescope-luasnip.nvim',
        module = 'telescope._extensions.luasnip',
        event = 'VeryLazy',
    },

    -- surround, delete around, etc.
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

    {
        'iamcco/markdown-preview.nvim',
        cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
        build = 'cd app && npm install',
        init = function()
            vim.g.mkdp_filetypes = { 'markdown' }
        end,
        ft = { 'markdown' },
    },

    -- better loclist && qflist
    {
        'folke/trouble.nvim',
        opts = {}, -- default
        cmd = 'Trouble',
    },

    -- faster typescript lsp
    {
        'pmizio/typescript-tools.nvim',
        filetypes = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' },
        config = function()
            require 'configs.ts_tools'
        end,
    },

    -- enhances the native commentstring on react
    {
        'folke/ts-comments.nvim',
        enabled = true,
        filetypes = { 'typescriptreact', 'javascriptreact' },
        opts = {
            lang = {
                javascript = {
                    '// %s', -- default commentstring when no treesitter node matches
                    '/* %s */',
                    call_expression = '// %s', -- specific commentstring for call_expression
                    jsx_attribute = '// %s',
                    jsx_element = '{/* %s */}',
                    jsx_fragment = '{/* %s */}',
                    spread_element = '// %s',
                    statement_block = '// %s',
                },
                tsx = {
                    '// %s', -- default commentstring when no treesitter node matches
                    '/* %s */',
                    call_expression = '// %s', -- specific commentstring for call_expression
                    jsx_attribute = '// %s',
                    jsx_element = '{/* %s */}',
                    jsx_fragment = '{/* %s */}',
                    spread_element = '// %s',
                    statement_block = '// %s',
                },
            },
        },
    },

    -- provide bg color on color vals
    {
        'brenoprata10/nvim-highlight-colors',
        event = 'VeryLazy',
        config = function()
            require 'configs.highlight_colors'
        end,
    },

    -- better bufdelete
    {
        'echasnovski/mini.bufremove',
        event = 'VeryLazy',
        version = '*',
    },

    -- active scope indentation guide
    {
        'echasnovski/mini.indentscope',
        version = false,
        event = { 'BufReadPost', 'BufNewFile' },
        -- opts = {
        --   symbol = '│',
        --   options = { try_as_border = true },
        -- },
        --
        opts = function()
            local indentscope = require 'mini.indentscope'
            return {
                symbol = '│',
                options = { try_as_border = true },
                draw = {
                    delay = 0,
                    animation = indentscope.gen_animation.none(),
                },
            }
        end,
        init = function()
            vim.api.nvim_create_autocmd('FileType', {
                pattern = {
                    'help',
                    'alpha',
                    'dashboard',
                    'neo-tree',
                    'Trouble',
                    'lazy',
                    'mason',
                    'notify',
                    'toggleterm',
                    'snacks_dashboard',
                    'snacks_notif',
                    'snacks_terminal',
                    'snacks_win',
                },
                callback = function()
                    vim.b.miniindentscope_disable = true
                end,
            })
        end,
    },

    -- tests
    -- {
    --     'nvim-neotest/neotest',
    --     event = 'VeryLazy',
    --     dependencies = {
    --         'nvim-neotest/nvim-nio',
    --         'antoinemadec/FixCursorHold.nvim',
    --         'marilari88/neotest-vitest',
    --         'nvim-neotest/neotest-jest',
    --     },
    --     config = function()
    --         require('neotest').setup {
    --             adapters = {
    --                 require 'neotest-vitest',
    --                 require 'neotest-jest',
    --             },
    --         }
    --     end,
    -- },

    -- ai integration
    -- {
    --     'yetone/avante.nvim',
    --     event = 'VeryLazy',
    --     version = false, -- should always be false
    --     build = 'make',
    --     dependencies = {
    --         'MunifTanjim/nui.nvim',
    --         'zbirenbaum/copilot.lua', -- for providers='copilot'
    --         {
    --             -- support for image pasting
    --             'HakonHarnes/img-clip.nvim',
    --             event = 'VeryLazy',
    --             opts = {
    --                 default = {
    --                     embed_image_as_base64 = false,
    --                     prompt_for_file_name = false,
    --                     drag_and_drop = {
    --                         insert_mode = true,
    --                     },
    --                     use_absolute_path = true,
    --                 },
    --             },
    --         },
    --         {
    --             'MeanderingProgrammer/render-markdown.nvim',
    --             opts = {
    --                 file_types = { 'markdown', 'Avante' },
    --             },
    --             ft = { 'markdown', 'Avante' },
    --         },
    --     },
    --     config = function()
    --         return require 'configs.avante'
    --     end,
    -- },

    {
        'zbirenbaum/copilot.lua',
        cmd = 'Copilot',
        event = 'InsertEnter',
        requires = {
            'copilotlsp-nvim/copilot-lsp', -- for NES
        },
        config = function()
            require 'configs.copilot'
        end,
    },

    {
        'CopilotC-Nvim/CopilotChat.nvim',
        build = 'make tiktoken',
        opts = {
            model = 'gpt-5.2',
            temperature = 0.1, -- Lower = focused, higher = creative
            window = {
                layout = 'vertical',
                width = 0.4,
            },
            auto_insert_mode = true,
        },
    },
}
