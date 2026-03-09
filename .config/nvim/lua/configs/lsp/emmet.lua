return {
    cmd = { 'emmet-language-server', '--stdio' },
    filetypes = {
        'css',
        'sass',
        'scss',
        'html',
        'ejs',
        'pug',
        'javascript',
        'typescript',
        'javascriptreact',
        'typescriptreact',
        'vue',
    },
    init_options = {
        showAbbreviationSuggestions = true,
        showExpandedAbbreviation = 'always',
        showSuggestionsAsSnippets = false,
    },
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
}
