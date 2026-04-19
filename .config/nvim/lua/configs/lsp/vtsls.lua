return {
    cmd = { 'vtsls', '--stdio' },

    settings = {
        typescript = {
            updateImportsOnFileMove = { enabled = 'always' },
        },
        javascript = {
            updateImportsOnFileMove = { enabled = 'always' },
        },
    },

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
        local root_markers = { 'package-lock.json', 'yarn.lock', 'pnpm-lock.yaml', 'bun.lockb', 'bun.lock' }
        root_markers = vim.fn.has 'nvim-0.11.3' == 1 and { root_markers, { '.git' } } or vim.list_extend(root_markers, { '.git' })

        -- exclude deno
        local deno_root = vim.fs.root(bufnr, { 'deno.json', 'deno.jsonc' })
        local deno_lock_root = vim.fs.root(bufnr, { 'deno.lock' })
        local project_root = vim.fs.root(bufnr, root_markers)

        if deno_lock_root and (not project_root or #deno_lock_root > #project_root) then
            -- deno lock is closer than package manager lock, abort
            return
        end

        if deno_root and (not project_root or #deno_root >= #project_root) then
            -- deno config is closer than or equal to package manager lock, abort
            return
        end

        -- project is standard TS, not deno
        -- We fallback to the current working directory if no project root is found
        on_dir(project_root or vim.fn.getcwd())
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
