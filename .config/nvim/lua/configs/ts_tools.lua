require('typescript-tools').setup {
    -- handlers = {},
    root_dir = function(bufnr, on_dir)
        local root_markers = { 'package-lock.json', 'yarn.lock', 'pnpm-lock.yaml', 'bun.lockb', 'bun.lock' }
        -- Give the root markers equal priority by wrapping them in a table
        root_markers = { root_markers, { '.git' } } or vim.list_extend(root_markers, { '.git' })

        -- exclude deno
        if vim.fs.root(bufnr, { 'deno.json', 'deno.lock' }) then
            return
        end

        -- We fallback to the current working directory if no project root is found
        local project_root = vim.fs.root(bufnr, root_markers) or vim.fn.getcwd()

        on_dir(project_root)
    end,
    settings = {
        separate_diagnostic_server = false,
        single_file_support = true,
        publish_diagnostic_on = 'insert_leave',
        expose_as_code_action = {},
        tsserver_path = nil,
        tsserver_max_memory = 'auto',
        tsserver_locale = 'en',
        complete_function_calls = true,
        include_completions_with_insert_text = true,
        code_lens = 'off',
        disable_member_code_lens = true,
        jsx_close_tag = {
            enable = false,
            filetypes = { 'javascriptreact', 'typescriptreact' },
        },
        tsserver_file_preferences = {
            includeInlayParameterNameHints = 'all',
            includeCompletionsForModuleExports = true,
            quotePreference = 'auto',
        },
        tsserver_format_options = {
            allowIncompleteCompletions = false,
            allowRenameOfImportPath = false,
        },
        tsserver_plugins = {
            -- for TypeScript v4.9+
            -- '@styled/typescript-styled-plugin',
            -- or for older TypeScript versions
            -- 'typescript-styled-plugin',
        },
    },
}
