-- return {
--     cmd = { 'sqls' },
--     filetypes = { 'sql', 'mysql' },
--     root_markers = { 'config.yml' },
--     settings = {},
-- }
return {
    cmd = { 'sql-language-server', 'up', '--method', 'stdio' },
    filetypes = { 'sql', 'mysql' },
    root_markers = { '.sqllsrc.json' },
    settings = {},
}
