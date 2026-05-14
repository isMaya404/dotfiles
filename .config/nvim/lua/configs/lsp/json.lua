vim.filetype.add {
    filename = {
        ['tsconfig.json'] = 'jsonc',
        ['.eslintrc.json'] = 'jsonc',
        ['deno.json'] = 'jsonc',
    },
}

return {
    cmd = { 'vscode-json-language-server', '--stdio' },
    filetypes = { 'json', 'jsonc' },
    init_options = {
        provideFormatter = true,
    },
    root_markers = { '.git' },
    settings = {
        json = {
            -- specific schemas for better autocompletion
            -- schemas = require('schemastore').json.schemas(),

            -- Lazy install:
            -- {
            --   "b0o/SchemaStore.nvim",
            --   lazy = true, -- Only loads when called by jsonls
            -- }
            validate = { enable = true },
        },
    },
    validate = { enable = true },
}
