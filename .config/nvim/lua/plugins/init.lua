return {
    { 'nvim-lua/plenary.nvim', event = 'VeryLazy' },

    -- colorscheme
    {
        'gbprod/nord.nvim',
        lazy = false,
        priority = 1000,
        overrides = {
            NormalFloat = { bg = 'none' },
            FloatBorder = { bg = 'none' },
        },
        config = function()
            require('nord').setup {
                transparent = false,
            }
            vim.cmd.colorscheme 'nord'
        end,
    },

    -- install = {
    --     colorscheme = { 'nord' },
    -- },
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

    -- {
    --     'stevearc/resession.nvim',
    --     -- event = 'VimEnter',
    --     lazy = false,
    --     dependencies = {
    --         {
    --             'tiagovla/scope.nvim',
    --             lazy = false,
    --             config = true,
    --         },
    --     },
    --     config = function()
    --         require 'configs.resession'
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

    -- {
    --     'akinsho/bufferline.nvim',
    --     event = 'BufReadPost',
    --     version = '*',
    --     config = function()
    --         require 'configs.bufferline'
    --     end,
    -- },

    {
        'tpope/vim-sleuth',
        event = { 'BufReadPre', 'BufNewFile' },
    },

    -- auto pair paren, brackets, quotes, etc.
    {
        'windwp/nvim-autopairs',
        event = { 'InsertEnter' },
        opts = {
            fast_wrap = {},
            disable_filetype = { 'TelescopePrompt', 'vim' },
        },
        -- config = function(_, opts)
        --     require('nvim-autopairs').setup(opts)
        --     -- require('nvim-autopairs').enable_cmdline()
        -- end,
    },

    -- git integrations

    {
        'tpope/vim-fugitive',
        cmd = { 'G', 'Git' },
    },

    {
        'sindrets/diffview.nvim',
        cmd = {
            'DiffviewOpen',
            'DiffviewClose',
            'DiffviewFileHistory',
            'DiffviewFocusFiles',
            'DiffviewLog',
            'DiffviewRefresh',
            'DiffviewToggleFiles',
        },

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
        event = 'BufReadPre',
        config = function()
            require 'configs.gitsigns'
        end,
    },

    -- file tree
    {
        'stevearc/oil.nvim',
        opts = {},
        cmd = 'Oil',
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
        branch = 'harpoon2',
        keys = {
            {
                '<leader>h',
                function()
                    require('harpoon').ui:toggle_quick_menu(require('harpoon'):list())
                end,
                desc = 'Harpoon Menu',
            },
            {
                '<leader>.',
                function()
                    require('harpoon'):list():add()
                    vim.cmd 'doautocmd User HarpoonUpdated'
                end,
                desc = 'Harpoon Add',
            },
            {
                '<C-j>',
                function()
                    require('harpoon'):list():select(1)
                    vim.cmd 'doautocmd User HarpoonUpdated'
                end,
                desc = 'Harpoon Jump 1',
            },
            {
                '<C-k>',
                function()
                    require('harpoon'):list():select(2)
                    vim.cmd 'doautocmd User HarpoonUpdated'
                end,
                desc = 'Harpoon Jump 2',
            },
            {
                '<C-l>',
                function()
                    require('harpoon'):list():select(3)
                    vim.cmd 'doautocmd User HarpoonUpdated'
                end,
                desc = 'Harpoon Jump 3',
            },
            {
                '<C-p>',
                function()
                    require('harpoon'):list():select(4)
                    vim.cmd 'doautocmd User HarpoonUpdated'
                end,
                desc = 'Harpoon Jump 4',
            },
        },
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
            {
                'nvim-telescope/telescope-live-grep-args.nvim',
            },

            { 'nvim-telescope/telescope-ui-select.nvim' },

            {
                'nvim-telescope/telescope-frecency.nvim',
                version = '*',
            },

            {
                'smartpde/telescope-recent-files',
            },

            {
                'benfowler/telescope-luasnip.nvim',
            },
        },
        config = function()
            require 'configs.telescope'
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

    -- configures LuaLS for editing neovim
    {
        'folke/lazydev.nvim',
        ft = 'lua',
        opts = {
            library = {
                { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
            },
        },
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

    -- -- linter
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

    {
        'mfussenegger/nvim-lint',
        event = { 'BufReadPre', 'BufNewFile' },
        config = function()
            local lint = require 'lint'
            lint.linters_by_ft = {
                javascript = { 'eslint_d' },
                typescript = { 'eslint_d' },
                javascriptreact = { 'eslint_d' },
                typescriptreact = { 'eslint_d' },
            }

            -- autocmd to trigger linting
            vim.api.nvim_create_autocmd({ 'BufWritePost', 'BufEnter', 'InsertLeave' }, {
                callback = function()
                    lint.try_lint()
                end,
            })
        end,
    },

    -- formatter
    {
        'stevearc/conform.nvim',
        event = 'BufWritePre',
        config = function()
            require 'configs.conform'
        end,
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

    -- {
    --     'iamcco/markdown-preview.nvim',
    --     cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    --     build = 'cd app && npm install',
    --     init = function()
    --         vim.g.mkdp_filetypes = { 'markdown' }
    --     end,
    --     ft = { 'markdown' },
    -- },

    -- better loclist && qflist
    {
        'folke/trouble.nvim',
        opts = {}, -- default
        cmd = 'Trouble',
    },

    -- faster typescript lsp
    -- {
    --     'pmizio/typescript-tools.nvim',
    --     filetypes = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' },
    --     cond = function()
    --         -- disable plugin if we're in a deno project
    --         return not vim.fs.root(0, { 'deno.json', 'deno.jsonc', 'deno.lock' })
    --     end,
    --     config = function()
    --         require 'configs.ts_tools'
    --     end,
    -- },

    -- enhances nvim's native comment strings
    {
        'folke/ts-comments.nvim',
        opts = {},
        event = 'VeryLazy',
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
    -- {
    --     'echasnovski/mini.bufremove',
    --     event = 'VeryLazy',
    --     version = '*',
    -- },

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
    {
        'yetone/avante.nvim',
        event = 'VeryLazy',
        version = false, -- should always be false
        build = 'make',
        dependencies = {
            'MunifTanjim/nui.nvim',
            'zbirenbaum/copilot.lua', -- for providers='copilot'
            {
                -- support for image pasting
                'HakonHarnes/img-clip.nvim',
                event = 'VeryLazy',
                opts = {
                    default = {
                        embed_image_as_base64 = false,
                        prompt_for_file_name = false,
                        drag_and_drop = {
                            insert_mode = true,
                        },
                        use_absolute_path = true,
                    },
                },
            },

            -- {
            --     'MeanderingProgrammer/render-markdown.nvim',
            --     opts = {
            --         file_types = { 'markdown', 'Avante' },
            --     },
            --     ft = { 'markdown', 'Avante' },
            -- },
        },
        config = function()
            return require 'configs.avante'
        end,
    },

    -- {
    --     'zbirenbaum/copilot.lua',
    --     event = 'InsertEnter',
    --     -- dependencies = {
    --         -- 'copilotlsp-nvim/copilot-lsp', -- for NES
    --     -- },
    --     config = function()
    --         require 'configs.copilot'
    --     end,
    -- },

    {
        'CopilotC-Nvim/CopilotChat.nvim',
        event = 'VeryLazy',
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
