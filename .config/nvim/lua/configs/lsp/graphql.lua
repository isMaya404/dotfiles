return {
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
}
