-- INFO: Since 'space' is used as a binding in keybindings.json, leader bindings won't in this config
-- this is because every space key press, vscode will only listen for bindings that's native to it's own.

local map = vim.keymap.set
local unmap = vim.keymap.unset
local opts = { silent = true, noremap = true }

local vscode = require 'vscode'

local function call(cmd)
    return function()
        vscode.call(cmd)
    end
end

local function code_action(kind)
    return function()
        vscode.call('editor.action.codeAction', {
            args = {
                kind = kind,
                apply = 'first', -- Equivalent to apply = true
            },
        })
    end
end

-- These are here and not in keybindings.json since built-in nvim 'g' bindings breaks.
map('n', 'glf', code_action 'source.fixAll')
map('n', 'gmi', code_action 'source.addMissingImports')
map('n', 'gru', code_action 'source.organizeImports')
map('n', 'gq', code_action 'quickfix')
map('n', 'grU', code_action 'source.removeUnused')

map('n', 'gf', call 'editor.action.openLink') -- works for both file paths and URL's
map('n', 'ga', call 'editor.action.codeAction')
map('n', 'grn', call 'editor.action.rename')
-- map('n', 'gd', call 'editor.action.revealDefinition')
map('n', 'gd', call 'editor.action.revealDefinitionAside')
map('n', 'gD', call 'editor.action.revealDeclaration')
-- map('n', 'grr', call 'editor.action.goToReferences')
map('n', 'grr', call 'references-view.findReferences')
map('n', 'grt', call 'editor.action.goToTypeDefinition')
map('n', 'gri', call 'editor.action.goToImplementation')
map('n', 'gs', call 'editor.action.triggerParameterHints')
map('n', 'gS', call 'workbench.action.gotoSymbol')
map('n', 'grw', call 'workbench.action.showAllSymbols')

map('n', '<Esc>', '<cmd>nohlsearch<CR>')
map('n', '=ap', "ma=ap'a")

map({ 'n', 'x' }, '<C-d>', '<C-d>zz', opts)
map({ 'n', 'x' }, '<C-u>', '<C-u>zz', opts)

map({ 'n', 'x' }, '<C-f>', '<C-f>zz', opts)
map({ 'n', 'x' }, '<C-b>', '<C-b>zz', opts)

-- map('n', '<M-s>', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = '' })

-- Better indent
map('v', '<', '<gv', { remap = true })
map('v', '>', '>gv', { remap = true })

map({ 'n', 'x', 'o' }, '<C-y>', '<Nop>')
map({ 'n', 'x', 'o' }, '<C-e>', '<Nop>')

-------------------- Remap --------------------

map('c', '<Up>', '<Nop>', opts)
map('c', '<Down>', '<Nop>', opts)
map({ 'n', 'x', 'o' }, '<Up>', "v:count == 0 ? 'gk' : 'k'", { desc = 'Up', expr = true, silent = true })
map({ 'n', 'x', 'o' }, '<Down>', "v:count == 0 ? 'gj' : 'j'", { desc = 'Down', expr = true, silent = true })

map('n', 'Q', '@@')

map({ 'n', 'x' }, ';', ':', { noremap = true })
map({ 'n', 'x' }, ':', ',', opts)
map({ 'n', 'x' }, ',', ';', opts)

map({ 'n', 'x', 'o' }, 'j', 'h', opts)
map({ 'n', 'x', 'o' }, 'p', 'l', opts)

map({ 'o' }, 'k', 'j', opts)
map({ 'o' }, 'l', 'k', opts)
map({ 'n', 'x' }, 'k', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ 'n', 'x' }, 'l', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

map({ 'n', 'x', 'o' }, 'h', 'p', opts)
map({ 'n', 'x', 'o' }, 'H', 'P', opts)

map({ 'n', 'v', 'x', 'o' }, 'J', 'H', opts)
map('n', 'K', call 'editor.action.showHover')

map({ 'n', 'x' }, 'L', 'M', opts)
map({ 'n', 'x', 'o' }, 'P', 'L', opts)

map({ 'n', 'x', 'o' }, 'b', 'nzzzv', opts)
map({ 'n', 'x', 'o' }, 'B', 'Nzzzv', opts)
map({ 'n', 'x', 'o' }, 'n', 'b', opts)
map({ 'n', 'x', 'o' }, 'N', 'B', opts)

map({ 'n', 'x', 'o' }, 'o', 'y', opts)
map({ 'n', 'x', 'o' }, 'O', 'y$', opts)
map({ 'n', 'x', 'o' }, 'm', 'o', opts)
map({ 'n', 'x', 'o' }, 'M', 'O', opts)
map({ 'n', 'x', 'o' }, 'y', 'm', opts)
map({ 'n', 'x', 'o' }, 'Y', 'J', opts)
