return {
    cmd = { 'tsgo', '--lsp', '--stdio' },
    filetypes = {
        'javascript',
        'typescript',
        'javascriptreact',
        'typescriptreact',
    },
    root_dir = function(bufnr, on_dir)
        local root_markers = { 'package-lock.json', 'yarn.lock', 'pnpm-lock.yaml', 'bun.lockb', 'bun.lock' }
        -- Give the root markers equal priority by wrapping them in a table
        root_markers = vim.fn.has 'nvim-0.11.3' == 1 and { root_markers, { '.git' } } or vim.list_extend(root_markers, { '.git' })

        -- exclude deno
        if vim.fs.root(bufnr, { 'deno.jsonc', 'deno.json', 'deno.lock' }) then
            return
        end

        -- Fallback to the current working directory if no project root is found
        local project_root = vim.fs.root(bufnr, root_markers) or vim.fn.getcwd()

        on_dir(project_root)
    end,
    on_attach = function(_, bufnr)
        local opts = { buffer = bufnr }

        vim.keymap.set('n', 'glf', function()
            vim.lsp.buf.code_action {
                apply = true,
                context = { only = { 'source.fixAll' } },
            }
        end, opts)

        vim.keymap.set('n', 'gmi', function()
            vim.lsp.buf.code_action {
                apply = true,
                context = { only = { 'source.addMissingImports' } },
            }
        end, opts)

        vim.keymap.set('n', 'gru', function()
            vim.lsp.buf.code_action {
                apply = true,
                context = { only = { 'source.removeUnusedImports' } },
            }
        end, opts)

        vim.keymap.set('n', 'gqf', function()
            vim.lsp.buf.code_action {
                apply = true,
                context = { only = { 'quickfix' } },
            }
        end, opts)

        vim.keymap.set('n', 'grU', function()
            vim.lsp.buf.code_action {
                apply = true,
                context = { only = { 'source.removeUnused' } },
            }
        end, opts)
    end,
}
