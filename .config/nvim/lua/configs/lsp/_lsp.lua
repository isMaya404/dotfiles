-- require('neoconf').setup {}
local lspconfig = require 'lspconfig'
require('fidget').setup {}

local function map(lhs, rhs)
    vim.keymap.set('n', lhs, rhs, { buffer = bufnr })
end

vim.diagnostic.config {
    virtual_text = true,
    float = { border = 'rounded', source = 'if_many' },
    severity_sort = true,
    underline = false,
    signs = true,
    update_in_insert = true,
}

-- https://github.com/antosha417/nvim-lsp-file-operations
lspconfig.util.default_config = vim.tbl_extend('force', lspconfig.util.default_config, {
    capabilities = vim.tbl_deep_extend(
        'force',
        vim.lsp.protocol.make_client_capabilities(),
        -- returns configured operations if setup() was already called
        -- or default operations if not
        require('lsp-file-operations').default_capabilities()
    ),
})

-- disable semantic tokens provider
local function on_init(client, _)
    if client.supports_method 'textDocument/semanticTokens' then
        client.server_capabilities.semanticTokensProvider = nil
    end
end

local function on_attach(client, _)
    client.server_capabilities.documentHighlightProvider = false
end

local capabilities = require('cmp_nvim_lsp').default_capabilities()
-- local capabilities = require('blink.cmp').get_lsp_capabilities()

require('mason').setup()

local servers = {
    lua_ls = require 'configs.lsp.lua',
    -- tsgo = require 'configs.lsp.tsgo',
    -- ts_ls = 'configs.lsp.ts',
    denols = require 'configs.lsp.deno',
    -- vtsls = require 'configs.lsp.vtsls',
    emmet_language_server = require 'configs.lsp.emmet',
    tailwindcss = require 'configs.lsp.tailwindcss',
    pyright = require 'configs.lsp.python',
    jsonls = require 'configs.lsp.json',

    -- sqls = {
    --     cmd = { 'sqls' },
    --     filetypes = { 'sql', 'mysql' },
    --     root_markers = { 'config.yml' },
    --     settings = {},
    -- },

    -- cssls = {
    --     cmd = { 'vscode-css-language-server', '--stdio' },
    --     filetypes = { 'css', 'scss', 'less' },
    --     init_options = { provideFormatter = false },
    --     root_markers = { 'package.json', '.git' },
    --     settings = {
    --         css = { validate = true },
    --         scss = { validate = true },
    --     },
    -- },
    --
    -- html = {
    --     cmd = { 'vscode-html-language-server', '--stdio' },
    --     filetypes = { 'html', 'ejs', 'pug' },
    --     root_markers = { 'package.json', '.git' },
    --     init_options = { embeddedLanguages = { css = true, javascript = true } },
    -- },

    graphql = {
        cmd = { 'graphql-lsp', 'server', '-m', 'stream' },
        filetypes = { 'gql', 'graphql' }, -- maybe add js, ts, jsx, and tsx later on a better hardware
        root_dir = function(bufnr, on_dir)
            local fname = vim.api.nvim_buf_get_name(bufnr)
            on_dir(vim.lsp.cofig.util.root_pattern('.graphqlrc*', '.graphql.config.*', 'graphql.config.*')(fname))
        end,
        -- settings = {
        --     graphql = {
        --         schema = 'graphql.schema.json',
        --     },
        -- },
    },
}

require('mason-tool-installer').setup {
    ensure_installed = {
        -- lsp's
        'lua-language-server',
        'clangd',
        'tailwindcss-language-server',
        'typescript-language-server',
        'emmet-language-server',
        'vtsls',
        'denols',
        'tsgo',
        'css-lsp',
        'html-lsp',

        -- formatters
        'stylua',
        'prettier',
        'prettierd',
        'clang-format',
        'stylelint',
        'jsonlint',

        -- linters
        'eslint',
        'eslint_d',
        'markuplint',
        'stylelint',
        'jsonlint',
    },
    auto_update = true,
    run_on_start = false,
}

for name, config in pairs(servers) do
    local cfg = vim.tbl_deep_extend('force', {
        on_init = on_init,
        on_attach = on_attach,
        capabilities = capabilities,
        -- handlers = {
        --     ['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'rounded' }),
        --     ['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = 'rounded' }),
        -- },
    }, config or {})

    vim.lsp.config(name, cfg)
    vim.lsp.enable(name)
end
