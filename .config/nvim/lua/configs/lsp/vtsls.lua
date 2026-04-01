return {
    cmd = { 'vtsls', '--stdio' },
    init_options = {
        hostInfo = 'neovim',
    },
    filetypes = {
        'javascript',
        'typescript',
        'javascriptreact',
        'typescriptreact',
    },
    root_dir = function(bufnr, on_dir)
        local root_markers = { 'package-lock.json', 'yarn.lock', 'pnpm-lock.yaml', 'bun.lockb', 'bun.lock', '.git' }
        -- Give the root markers equal priority by wrapping them in a table
        root_markers = vim.fn.has 'nvim-0.11.3' == 1 and { root_markers, { '.git' } } or vim.list_extend(root_markers, { '.git' })

        -- exclude deno
        if vim.fs.root(bufnr, { 'deno.json', 'deno.jsonc', 'deno.lock' }) then
            return
        end

        -- We fallback to the current working directory if no project root is found
        local project_root = vim.fs.root(bufnr, root_markers) or vim.fn.getcwd()

        on_dir(project_root)
    end,
    on_attach = function(bufnr)
        local function apply_action(kind)
            vim.lsp.buf.code_action {
                apply = true,
                context = {
                    only = { kind },
                    diagnostics = vim.diagnostic.get(bufnr),
                },
            }
        end

        vim.keymap.set('n', 'glf', function()
            apply_action 'source.fixAll'
        end, { desc = 'LSP: Fix all' })

        vim.keymap.set('n', 'gai', function()
            apply_action 'source.addMissingImports'
        end, { desc = 'LSP: Add missing imports' })

        vim.keymap.set('n', 'grU', function()
            apply_action 'source.removeUnused'
        end, { desc = 'LSP: Remove unused' })

        vim.keymap.set('n', 'gru', function()
            apply_action 'source.removeUnusedImports'
        end, { desc = 'LSP: Remove unused imports' })

        vim.keymap.set('n', 'gqf', function()
            apply_action 'quickfix'
        end, { desc = 'LSP: Quick fix' })
    end,
}
