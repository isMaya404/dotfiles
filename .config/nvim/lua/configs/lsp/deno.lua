return {
    cmd = { 'deno', 'lsp' },
    cmd_env = { NO_COLOR = true },
    filetypes = {
        'javascript',
        'javascriptreact',
        'javascript.jsx',
        'typescript',
        'typescriptreact',
        'typescript.tsx',
    },
    root_dir = function(bufnr, on_dir)
        local root_markers = { 'deno.json', 'deno.jsonc', 'deno.lock' }
        root_markers = { root_markers, { '.git' } } or vim.list_extend(root_markers, { '.git' })
        local project_root = vim.fs.root(bufnr, root_markers)

        local non_deno_path = vim.fs.root(bufnr, { 'package.json', 'package-lock.json', 'yarn.lock', 'pnpm-lock.yaml', 'bun.lockb', 'bun.lock' })

        if non_deno_path and (not project_root or #non_deno_path >= #project_root) then
            return
        end

        -- fallback to the current working directory if no project root is found
        on_dir(project_root or vim.fn.getcwd())
    end,
    settings = {
        deno = {
            enable = true,
            lint = true,
            unstable = true,
            suggest = {
                imports = {
                    hosts = {
                        ['https://deno.land'] = true,
                        -- ['https://jsr.io'] = true,
                        -- ['https://esm.sh'] = true,
                    },
                },
            },
        },
    },
    handlers = (function()
        local lsp = vim.lsp

        -- handle virtual text documents from Deno (for definitions, etc.)
        local function virtual_text_document_handler(uri, res, client)
            if not res then
                return
            end
            local lines = vim.split(res.result, '\n')
            local bufnr = vim.uri_to_bufnr(uri)
            if vim.api.nvim_buf_line_count(bufnr) ~= 1 or vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)[1] ~= '' then
                return
            end
            vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
            vim.api.nvim_set_option_value('readonly', true, { buf = bufnr })
            vim.api.nvim_set_option_value('modifiable', false, { buf = bufnr })
            lsp.buf_attach_client(bufnr, client.id)
        end

        local function virtual_text_document(uri, client)
            local params = { textDocument = { uri = uri } }
            local result = client:request_sync('deno/virtualTextDocument', params)
            virtual_text_document_handler(uri, result, client)
        end

        local function denols_handler(err, result, ctx, config)
            if not result or vim.tbl_isempty(result) then
                return
            end
            local client = vim.lsp.get_client_by_id(ctx.client_id)
            for _, res in pairs(result) do
                local uri = res.uri or res.targetUri
                if uri:match '^deno:' then
                    virtual_text_document(uri, client)
                    res.uri, res.targetUri = uri, uri
                end
            end
            lsp.handlers[ctx.method](err, result, ctx, config)
        end

        return {
            ['textDocument/definition'] = denols_handler,
            ['textDocument/typeDefinition'] = denols_handler,
            ['textDocument/references'] = denols_handler,
        }
    end)(),
    on_attach = function(client, bufnr)
        -- disable semantic tokens like the rest of your setup
        if client.supports_method 'textDocument/semanticTokens' then
            client.server_capabilities.semanticTokensProvider = nil
        end

        vim.api.nvim_buf_create_user_command(bufnr, 'LspDenolsCache', function()
            client:exec_cmd({
                command = 'deno.cache',
                arguments = { {}, vim.uri_from_bufnr(bufnr) },
            }, { bufnr = bufnr }, function(err, _, ctx)
                if err then
                    local uri = ctx.params.arguments[2]
                    vim.notify('cache command failed for ' .. vim.uri_to_fname(uri), vim.log.levels.ERROR)
                end
            end)
        end, {
            desc = 'Cache a Deno module and its dependencies',
        })

        vim.keymap.set('n', 'gai', function()
            vim.lsp.buf.code_action {
                apply = true,
                context = { only = { 'quickfix' } },
            }
        end)

        vim.keymap.set('n', 'glf', function()
            vim.lsp.buf.code_action {
                apply = true,
                context = { only = { 'source.fixAll' } },
            }
        end)
    end,
}
