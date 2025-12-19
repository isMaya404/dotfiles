return {
    cmd = { 'vtsls', '--stdio' },
    init_options = {
        hostInfo = 'neovim',
    },
    filetypes = {
        'javascript',
        'javascriptreact',
        'javascript.jsx',
        'typescript',
        'typescriptreact',
        'typescript.tsx',
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
    on_attach = function(client, bufnr)
        -- fix all
        vim.keymap.set('n', 'glf', function()
            vim.lsp.buf.code_action {
                apply = true,
                context = { only = { 'source.fixAll' } },
            }
        end)

        -- add missing imports
        vim.keymap.set('n', 'gai', function()
            vim.lsp.buf.code_action {
                apply = true,
                context = { only = { 'source.addMissingImports.ts' } },
            }
        end)

        -- remove unused imports
        vim.keymap.set('n', 'gru', function()
            vim.lsp.buf.code_action {
                apply = true,
                context = { only = { 'source.removeUnusedImports' } },
            }
        end)
    end,
}
