local avante = require 'avante'

local opts = {
    ---@alias avante.Mode "agentic" | "legacy"
    mode = 'legacy',

    provider = 'copilot',
    auto_suggestions_provider = 'copilot',

    instructions_file = 'avante.md',

    providers = {
        copilot = {
            endpoint = 'https://api.githubcopilot.com',
            -- model = 'gpt-5',
            model = 'gpt-5-codex',
            allow_insecure = false,
            timeout = 30000,
            context_window = 64000, -- Number of tokens to send to the model for context
            use_response_api = copilot_use_response_api, -- Automatically switch to Response API for GPT-5 Codex models
            support_previous_response_id = false, -- Copilot doesn't support previous_response_id, must send full history
            extra_request_body = {
                -- temperature is not supported by Response API for reasoning models
                max_tokens = 20480,

                reasoning_effort = 'high',
            },
        },

        -- groq = {
        --   __inherited_from = 'copilot',
        --   api_key_name = 'GROQ_API_KEY',
        --   endpoint = 'https://api.groq.com/openai/v1/',
        --   model = 'llama-3.3-70b-versatile',
        --   disable_tools = true,
        --   extra_request_body = {
        --     temperature = 0.7,
        --     max_tokens = 32768,
        --   },
        -- },
        --
        -- openai = {
        --   endpoint = 'https://api.openai.com/v1',
        --   model = 'gpt-3.5-turbo',
        --   timeout = 30000,
        --   extra_request_body = {
        --     temperature = 0,
        --     max_completion_tokens = 4096,
        --   },
        -- },
    },

    web_search_engine = {
        provider = 'google',
    },

    -- dual_boost = {
    --     enabled = false,
    --     first_provider = 'openai',
    --     second_provider = 'claude',
    --     prompt = 'Based on the two reference outputs below, generate a response that incorporates elements from both but reflects your own judgment and unique perspective. Do not provide any explanation, just give the response directly. Reference Output 1: [{{provider1_output}}], Reference Output 2: [{{provider2_output}}]',
    --     timeout = 60000,
    -- },
    --
    behaviour = {
        auto_suggestions = false,
        auto_set_highlight_group = true,
        auto_set_keymaps = true,
        auto_apply_diff_after_generation = false,
        jump_result_buffer_on_finish = false,
        support_paste_from_clipboard = false,
        minimize_diff = true,
        enable_token_counting = true,
        enable_cursor_planning_mode = true,
        auto_add_current_file = true,
        auto_approve_tool_permissions = true, -- auto-approve all tools (no prompts)
        -- Examples:
        -- auto_approve_tool_permissions = false,
        -- auto_approve_tool_permissions = {"bash", "str_replace"},
        ---@type "popup" | "inline_buttons"
        confirmation_ui_style = 'inline_buttons',
        --- Whether to automatically open files and navigate to lines when ACP agent makes edits
        ---@type boolean
        acp_follow_agent_locations = true,
    },
    prompt_logger = { -- logs prompts to disk (timestamped, for replay/debugging)
        enabled = false, -- toggle logging entirely
        log_dir = vim.fn.stdpath 'cache' .. '/avante_prompts', -- directory where logs are saved
        fortune_cookie_on_success = false, -- shows a random fortune after each logged prompt (requires `fortune` installed)
        next_prompt = {
            normal = '<C-n>', -- load the next (newer) prompt log in normal mode
            insert = '<C-n>',
        },
        prev_prompt = {
            normal = '<C-p>', -- load the previous (older) prompt log in normal mode
            insert = '<C-p>',
        },
    },

    mappings = {
        diff = {
            ours = 'co',
            theirs = 'ct',
            all_theirs = 'ca',
            both = 'cb',
            cursor = 'cc',
            next = ']x',
            prev = '[x',
        },
        suggestion = {
            accept = '<M-l>',
            dismiss = '<C-k>',
            next = '<M-d>',
            prev = '<M-s>',
        },
        jump = {
            next = ']]',
            prev = '[[',
        },
        submit = {
            normal = '<CR>',
            insert = '<CR>',
        },
        cancel = {
            normal = { '<C-c>', '<Esc>', 'q' },
            insert = { '<C-c>' },
        },
        sidebar = {
            apply_all = 'A',
            apply_cursor = 'a',
            switch_windows = '<Tab>',
            reverse_switch_windows = '<S-Tab>',
        },
        ask = '<leader>av',
    },

    hints = { enabled = true },

    windows = {
        position = 'right',
        wrap = true,
        width = 25,
        sidebar_header = {
            enabled = true,
            align = 'center',
            rounded = true,
        },
        input = {
            prefix = '>',
            height = 10,
        },
        edit = {
            border = 'rounded',
            start_insert = true,
        },
        ask = {
            floating = false,
            start_insert = true,
            border = 'rounded',
            focus_on_apply = 'ours',
        },
    },

    highlights = {
        diff = {
            current = 'DiffText',
            incoming = 'DiffAdd',
        },
    },

    diff = {
        autojump = true,
        list_opener = 'copen',
        override_timeoutlen = 500,
    },

    suggestion = {
        debounce = 600,
        throttle = 600,
    },
}

avante.setup(opts)
