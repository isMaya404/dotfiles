return {
    cmd = { 'emmet-language-server', '--stdio' },
    filetypes = {
        'css',
        'sass',
        'scss',
        'html',
        'ejs',
        'pug',
        'javascript',
        'typescript',
        'javascriptreact',
        'typescriptreact',
        'vue',
    },
    init_options = {
        showAbbreviationSuggestions = true,
        showExpandedAbbreviation = 'always',
        showSuggestionsAsSnippets = false,
    },
    root_markers = { 'package-lock.json', '.git' },
}
