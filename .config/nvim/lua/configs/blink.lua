local blink_cmp = require 'blink.cmp'
local luasnip = require 'luasnip'

local opts = {
    enabled = function()
        return not vim.tbl_contains({
            'NvimTree',
            'Telescope',
            'DressingInput',
            'TelescopePrompt',
        }, vim.bo.filetype) and vim.bo.buftype ~= 'prompt' and vim.b.completion ~= false
    end,

    fuzzy = { implementation = 'prefer_rust_with_warning' },

    signature = {
        enabled = true,
        window = {
            border = 'rounded',
            show_documentation = false,
        },
    },

    appearance = {
        nerd_font_variant = 'mono',
    },

    sources = {
        default = {
            'lsp',
            'buffer',
            'path',
            'snippets',
        },
        per_filetype = {
            lua = { inherit_defaults = true, 'lazydev' },
        },
        providers = {
            lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
        },
    },

    snippets = { preset = 'luasnip' },

    keymap = {
        preset = 'default',

        ['<CR>'] = {
            'select_and_accept', -- if there's cmp
            'fallback', -- else normal Enter
        },

        ['<Up>'] = { 'select_prev', 'fallback' },
        ['<Down>'] = { 'select_next', 'fallback' },

        ['<Tab>'] = {
            function()
                if luasnip.expand_or_jumpable() then
                    luasnip.expand_or_jump()
                    return true
                end
            end,
            'select_next',
            'fallback',
        },

        ['<S-Tab>'] = {
            function()
                if luasnip.jumpable(-1) then
                    luasnip.jump(-1)
                    return true
                end
            end,
            'select_prev',
            'fallback',
        },

        ['<C-k>'] = { 'show_signature', 'hide_signature', 'fallback' },
        ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
        ['<C-y>'] = { 'select_and_accept' },
        ['<C-e>'] = { 'hide' },
    },

    completion = {
        accept = {
            auto_brackets = {
                enabled = true,
            },
        },

        documentation = {
            window = {
                border = 'rounded',
            },
            auto_show = true,
            auto_show_delay_ms = 100,
        },

        list = {
            selection = {
                preselect = true,
            },
        },

        menu = {
            border = 'rounded',
            winhighlight = 'Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,CursorLine:BlinkCmpDocCursorLine,Search:None',
            scrollbar = false,
            draw = {
                treesitter = { 'lsp' },
                columns = { { 'label', 'label_description', gap = 1 }, { 'kind_icon', 'kind' } },
                components = {
                    -- customize the drawing of kind icons
                    kind_icon = {
                        text = function(ctx)
                            -- default kind icon
                            local icon = ctx.kind_icon
                            -- if LSP source, check for color derived from documentation
                            if ctx.item.source_name == 'LSP' then
                                local color_item = require('nvim-highlight-colors').format(ctx.item.documentation, { kind = ctx.kind })
                                if color_item and color_item.abbr ~= '' then
                                    icon = color_item.abbr
                                end
                            end
                            return icon .. ctx.icon_gap
                        end,
                        highlight = function(ctx)
                            -- default highlight group
                            local highlight = 'BlinkCmpKind' .. ctx.kind
                            -- if LSP source, check for color derived from documentation
                            if ctx.item.source_name == 'LSP' then
                                local color_item = require('nvim-highlight-colors').format(ctx.item.documentation, { kind = ctx.kind })
                                if color_item and color_item.abbr_hl_group then
                                    highlight = color_item.abbr_hl_group
                                end
                            end
                            return highlight
                        end,
                    },
                },
            },
        },
    },

    term = {
        enabled = true,
        keymap = { preset = 'inherit' }, -- Inherits from top level `keymap` config when not set
        sources = {},
        completion = {
            trigger = {
                show_on_blocked_trigger_characters = {},
                show_on_x_blocked_trigger_characters = nil, -- Inherits from top level `completion.trigger.show_on_blocked_trigger_characters` config when not set
            },
            list = {
                selection = {
                    -- When `true`, will automatically select the first item in the completion list
                    preselect = nil,
                    -- When `true`, inserts the completion item automatically when selecting it
                    auto_insert = nil,
                },
            },
            -- Whether to automatically show the window when new completion items are available
            menu = { auto_show = nil },
            -- Displays a preview of the selected item on the current line
            ghost_text = { enabled = nil },
        },
    },

    cmdline = {
        enabled = true,
        keymap = {
            preset = 'none',
            ['<C-n>'] = { 'select_next', 'fallback' },
            ['<C-p>'] = { 'select_prev', 'fallback' },

            ['<Tab>'] = { 'show_and_insert_or_accept_single', 'select_next' },
            ['<S-Tab>'] = { 'show_and_insert_or_accept_single', 'select_prev' },

            ['<Down>'] = { 'show_and_insert_or_accept_single', 'select_next' },
            ['<Up>'] = { 'show_and_insert_or_accept_single', 'select_prev' },

            ['<C-space>'] = { 'show', 'fallback' },

            ['<CR>'] = { 'accept_and_enter', 'fallback' },
        },
        sources = {
            'buffer',
            'cmdline',
        },
        completion = {
            trigger = {
                show_on_blocked_trigger_characters = {},
                show_on_x_blocked_trigger_characters = {},
            },
            list = {
                selection = {
                    preselect = true,
                    auto_insert = true,
                },
            },
            menu = { auto_show = false },
            ghost_text = { enabled = false },
        },
    },
}
blink_cmp.setup(opts)
