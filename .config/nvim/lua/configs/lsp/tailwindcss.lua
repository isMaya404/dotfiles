return {
    cmd = { 'tailwindcss-language-server', '--stdio' },
    filetypes = {
        'ejs',
        'html',
        'markdown',
        'php',
        -- css
        'css',
        'sass',
        'scss',
        -- js
        'javascript',
        'javascriptreact',
        'typescript',
        'typescriptreact',
        -- mixed
        'vue',
        'svelte',
    },
    settings = {
        tailwindCSS = {
            validate = true,
            lint = {
                cssConflict = 'warning',
                invalidApply = 'error',
                invalidScreen = 'error',
                invalidVariant = 'error',
                invalidConfigPath = 'error',
                invalidTailwindDirective = 'error',
                recommendedVariantOrder = 'warning',
            },
            classAttributes = {
                'class',
                'className',
                'class:list',
                'classList',
                'ngClass',
            },
            includeLanguages = {
                eelixir = 'html-eex',
                elixir = 'phoenix-heex',
                eruby = 'erb',
                heex = 'phoenix-heex',
                htmlangular = 'html',
                templ = 'html',
            },
        },
    },
    before_init = function(_, config)
        if not config.settings then
            config.settings = {}
        end
        if not config.settings.editor then
            config.settings.editor = {}
        end
        if not config.settings.editor.tabSize then
            config.settings.editor.tabSize = vim.lsp.util.get_effective_tabstop()
        end
    end,
    root_dir = function(bufnr, on_dir)
        local util = require 'lspconfig.util'
        local root_files = {
            -- Generic
            'tailwind.config.js',
            'tailwind.config.cjs',
            'tailwind.config.mjs',
            'tailwind.config.ts',
            'postcss.config.js',
            'postcss.config.cjs',
            'postcss.config.mjs',
            'postcss.config.ts',
            -- Tailwind v4 fallback (no config file)
            'vite.config.ts',
            -- '.git',
        }

        local fname = vim.api.nvim_buf_get_name(bufnr)
        root_files = util.insert_package_json(root_files, 'tailwindcss', fname)
        root_files = util.root_markers_with_field(root_files, { 'mix.lock', 'Gemfile.lock' }, 'tailwind', fname)
        on_dir(vim.fs.dirname(vim.fs.find(root_files, { path = fname, upward = true })[1]))
    end,
}
