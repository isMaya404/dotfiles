return {
    cmd = { 'vscode-html-language-server', '--stdio' },
    filetypes = { 'html', 'ejs', 'pug' },
    root_markers = { 'package.json', '.git' },
    init_options = { embeddedLanguages = { css = true, javascript = true } },
}
