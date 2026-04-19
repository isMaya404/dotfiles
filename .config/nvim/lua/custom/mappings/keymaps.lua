local map = vim.keymap.set
-- local unmap = vim.keymap.del
local opts = { silent = true, noremap = true }

-- map('n', '<leader>mt', '<cmd>silent !ctags -R .<CR>', { desc = 'make tags' })

map('x', '<leader>p', [["_dP]], { desc = 'blackhole paste' })
map({ 'n', 'v' }, '<leader>d', [["_d]], { desc = 'blackhole delete' })
-- map({ 'n', 'v' }, '<leader>bx', [["_d]], { desc = 'blackhole x-delete' })

map('n', '<leader>s', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = 'Replace word in cursor' })
map('n', '<leader>q', '<cmd>qa<CR>')

-- Toggle spell checker. More useful paired with 'z=' to check spelling suggestions
-- map('n', '<leader>dn', '<cmd>setlocal spell! spelllang=en_us<CR>', { desc = 'dictionary' })

map('n', '<Esc>', '<cmd>nohlsearch<CR>')

map({ 'n', 'x', 'o' }, '<Down>', "v:count == 0 ? 'gj' : 'j'", { desc = 'Down', expr = true, silent = true })
map({ 'n', 'x', 'o' }, '<Up>', "v:count == 0 ? 'gk' : 'k'", { desc = 'Up', expr = true, silent = true })

map('n', '<leader><leader>s', '<cmd>source %<CR>')

map('i', '<M-i>', '<ESC>^i', { remap = true, desc = 'move beginning of line' })
map('i', '<M-o>', '<End>', { remap = true, desc = 'move end of line' })
map('i', '<M-d>', '<C-o>dw', { remap = true, desc = 'del word after cursor' })

map({ 'n', 'x' }, '<M-k>', '<C-d>zz', opts)
map({ 'n', 'x' }, '<M-l>', '<C-u>zz', opts)

map('n', '=ap', "ma=ap'a")

map('n', '<C-c>', '<cmd>%y+<CR>', { desc = 'copy whole file' })

-- Comments
map('n', '<leader>/', 'gcc', { desc = 'Toggle Comment', remap = true })
map('x', '<leader>/', 'gc', { desc = 'Toggle Comment', remap = true })

-- Move Line/s Up/Down
map('n', '<M-K>', "<cmd>execute 'move .+' . v:count1<cr>==", { desc = 'Move Down' })
map('i', '<M-K>', '<esc><cmd>m .+1<cr>==gi', { desc = 'Move Down' })
map('x', '<M-K>', ":move '>+1<CR>gv-gv", opts)
map('n', '<M-L>', "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = 'Move Up' })
map('i', '<M-L>', '<esc><cmd>m .-2<cr>==gi', { desc = 'Move Up' })
map('x', '<M-L>', ":move '<-2<CR>gv-gv", opts)

-- Better indent
map('v', '<', '<gv', { remap = true })
map('v', '>', '>gv', { remap = true })

-- Terminal
-- map({ 'n', 't' }, '<M-m>', function()
--     require('custom.terminal').toggle { pos = 'float', id = 'floatTerm' }
-- end, { desc = 'toggle floating term' })
-- map('t', '<M-n>', '<C-\\><C-N>', { desc = 'terminal escape terminal mode' })

-- Buffers
-- local function map_buffer_cmd(lhs, rhs, desc)
--     vim.keymap.set('n', lhs, function()
--         if vim.bo.filetype ~= 'NvimTree' then
--             vim.cmd(rhs)
--         end
--     end, { desc = desc, noremap = true, silent = true })
-- end
-- map_buffer_cmd('<Tab>', 'bnext', 'Next Buffer')
-- map_buffer_cmd('<S-Tab>', 'bprev', 'Prev Buffer')
map('n', '<Tab>', ':bnext<CR>', opts)
map('n', '<S-Tab>', ':bprevious<CR>', opts)
map('n', '<leader>j', '<C-^>', { desc = 'Switch to last buffer' })
map('n', '<leader>X', function()
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        local bt = vim.bo[buf].buftype
        if bt == '' or bt == 'acwrite' then
            pcall(vim.api.nvim_buf_delete, buf, { force = true })
        end
    end
end, { desc = 'Delete all normal buffers', silent = true })

-- map('n', '<leader>x', function()
--     local current_buf = vim.api.nvim_get_current_buf()
--     local listed_buffers = vim.tbl_filter(function(buf)
--         return vim.fn.buflisted(buf) == 1
--     end, vim.api.nvim_list_bufs())
--
--     local last_buf = listed_buffers[#listed_buffers]
--     local next_cmd = current_buf == last_buf and 'bprevious' or 'bnext'
--     vim.cmd(next_cmd)
--     require('mini.bufremove').delete(current_buf, false)
--     -- Built in alt of mini.bufremove:
--     -- vim.cmd('bd ' .. current_buf)
-- end, { desc = 'Close current buffer' })

-- Windows

-- unmap default window navigations
map({ 'n', 'x' }, '<C-w>h', '<Nop>')
map({ 'n', 'x' }, '<C-w><C-h>', '<Nop>')
map({ 'n', 'x' }, '<C-w>j', '<Nop>')
map({ 'n', 'x' }, '<C-w><C-j>', '<Nop>')
map({ 'n', 'x' }, '<C-w>k', '<Nop>')
map({ 'n', 'x' }, '<C-w><C-k>', '<Nop>')
map({ 'n', 'x' }, '<C-w>l', '<Nop>')
map({ 'n', 'x' }, '<C-w><C-l>', '<Nop>')

-- map new window navigations
map({ 'n', 'x' }, '<C-w>j', '<C-w>h')
map({ 'n', 'x' }, '<C-w><C-j>', '<C-w>h')
map({ 'n', 'x' }, '<C-w>k', '<C-w>j')
map({ 'n', 'x' }, '<C-w><C-k>', '<C-w>j')
map({ 'n', 'x' }, '<C-w>l', '<C-w>k')
map({ 'n', 'x' }, '<C-w><C-l>', '<C-w>k')
map({ 'n', 'x' }, '<C-w>p', '<C-w>l')
map({ 'n', 'x' }, '<C-w><C-p>', '<C-w>l')

map({ 'n', 'x' }, '<leader>wo', '<C-w>o')
map({ 'n', 'x' }, '<leader>wv', '<C-w>v')
map({ 'n', 'x' }, '<leader>wh', '<C-w>s')
map({ 'n', 'x' }, '<leader>we', '<C-w>=')

map({ 'n', 'x' }, '<leader><Down>', ':silent! resize -10<CR>')
map({ 'n', 'x' }, '<leader><Up>', ':silent! resize +10<CR>')
map({ 'n', 'x' }, '<leader><Right>', ':silent! vertical resize +10<CR>')
map({ 'n', 'x' }, '<leader><Left>', ':silent! vertical resize -10<CR>')

map({ 'n', 'x' }, '<C-w>r', '<C-l>', { desc = 'redraw screen' })

-- Bash Scripts
-- map({ 'n' }, '<M-idk', ':!tmux-windowizer $(git rev-parse --abbrev-ref HEAD) pnpm dev<CR><CR>')
map({ 'n' }, '<M-1>', ':!tmux-windowizer nn ')
map({ 'n' }, '<M-0>', ':!tmux-windowizer dev:fe pnpm dev:frontend<CR><CR>')
map({ 'n' }, '<M-9>', ':!tmux-windowizer dev:be pnpm dev:backend<CR><CR>')

--------------------------------------- Plugin Mappings ---------------------------------------

-- Nvim-Tree
map('n', '<leader>n', function()
    local nnp = require 'no-neck-pain'
    local nnp_state = require 'no-neck-pain.state'
    local nt_api = require 'nvim-tree.api'

    -- If NNP is open, close it first
    if nnp_state.enabled then
        nnp.toggle_side 'right'
        nnp.toggle()
    end

    nt_api.tree.toggle { focus = false }
end, { desc = 'NvimTree toggle window' })

map('n', '<leader>e', function()
    local nnp = require 'no-neck-pain'
    local nnp_state = require 'no-neck-pain.state'
    local nt_api = require 'nvim-tree.api'

    -- If NNP is open, close it first
    if nnp_state.enabled then
        nnp.toggle_side 'right'
        nnp.toggle()
    end

    -- defer to give the UI time to close
    vim.defer_fn(function()
        nt_api.tree.focus()
    end, 5)
end, { desc = 'NvimTree focus window' })

map('n', '<leader>,', function()
    local nnp = require 'no-neck-pain'
    local nnp_state = require 'no-neck-pain.state'
    local nt_view = require 'nvim-tree.view'
    local nt_api = require 'nvim-tree.api'

    -- If NvimTree is open, close it first
    if nt_view.is_visible() then
        nt_api.tree.close()
    end

    if nnp_state.enabled then
        nnp.toggle_side 'right'
        nnp.toggle()
        return
    end

    nnp.toggle()

    -- defer to give the UI time to initialize
    vim.defer_fn(function()
        nnp.resize(110)
        nnp.toggle_side 'right'
    end, 5)
end, { desc = 'NoNeckPain' })

map('n', '<leader>r', function()
    require('snacks').rename.rename_file()
end, { desc = 'Rename Current File' })

-- Bufferline
-- map('n', '<leader>j', '<Cmd>BufferLineGoToBuffer 1<CR>')
-- map('n', '<leader>k', '<Cmd>BufferLineGoToBuffer 2<CR>')
-- map('n', '<leader>l', '<Cmd>BufferLineGoToBuffer 3<CR>')
-- map('n', '<leader>p', '<Cmd>BufferLineGoToBuffer 4<CR>')
-- map('n', '<Tab>', '<cmd>BufferLineCycleNext<CR>')
-- map('n', '<S-Tab>', '<cmd>BufferLineCyclePrev<CR>')

-- Copilot Chat
map('n', '<leader>aif', '<Cmd>CopilotChatFix<CR>')
map('n', '<leader>aie', '<Cmd>CopilotChatExplain<CR>')
map('n', '<leader>ait', '<Cmd>CopilotChatToggle<CR>')

-- Ts-Tools
map('n', 'gru', '<Cmd>TSToolsRemoveUnusedImports<CR>', { desc = 'TS [R]emove [U]nused Imports' })
map('n', 'grU', '<Cmd>TSToolsRemoveUnused<CR>', { desc = 'TS Remove All [U]nused Statements' })
map('n', 'gmi', '<Cmd>TSToolsAddMissingImports<CR>', { desc = 'TS Add [M]issing [I]mports' })
map('n', 'glf', '<Cmd>TSToolsFixAll<CR>', { desc = 'TS Fix all' })

map('n', '<M-o>', '<CMD>Oil<CR>', { desc = 'Open parent directory' })

--  Copilot
local auto_trigger_enabled = true
map('n', '<leader>cp', function()
    auto_trigger_enabled = not auto_trigger_enabled

    if auto_trigger_enabled then
        print 'Copilot auto-suggestion: On'
    else
        print 'Copilot auto-suggestion: Off'
    end

    require('copilot.suggestion').toggle_auto_trigger()
end, { desc = 'Toggle Copilot Auto Suggestion' })

-- Whichkey
map('n', '<leader>wK', '<cmd>WhichKey <CR>', { desc = 'whichkey all keymaps' })
map('n', '<leader>wk', function()
    vim.cmd('WhichKey ' .. vim.fn.input 'WhichKey: ')
end, { desc = 'whichkey query lookup' })

-- Neotest
map('n', '<leader>ttr', function()
    require('neotest').run.run() -- run nearest test
end, opts)

map('n', '<leader>ttR', function()
    require('neotest').run.run(vim.fn.expand '%') -- run current file
end, opts)

map('n', '<leader>ttA', function()
    require('neotest').run.run { suite = true } -- run all test suite
end, opts)

map('n', '<leader>ttw', function()
    require('neotest').watch.toggle { vim.fn.expand '%' }
end, opts)

map('n', '<leader>tta', function()
    require('neotest').run.attach()
end, opts)

map('n', '<leader>tto', function()
    require('neotest').output_panel.toggle()
end, opts)

map('n', '<leader>tts', function()
    require('neotest').summary.toggle()
end, opts)

map('n', '<leader>ttjn', function()
    require('neotest').jump.next { status = 'failed' }
end, opts)
map('n', '<leader>ttjp', function()
    require('neotest').jump.prev { status = 'failed' }
end, opts)

-- TodoComments
-- map('n', ']t', function()
--     require('todo-comments').jump_next()
-- end, { desc = 'Next todo comment' })
--
-- map('n', '[t', function()
--     require('todo-comments').jump_prev()
-- end, { desc = 'Previous todo comment' })

-- Trouble
map('n', '<leader>tl', '<cmd>Trouble loclist toggle focus=true<CR>', { desc = '[T]rouble [L]ocation List' })
map('n', '<leader>tq', '<cmd>Trouble qflist toggle focus=true<CR>', { desc = '[T]rouble [Q]uickfix List' })
map('n', '<leader>tr', '<cmd>Trouble lsp toggle focus=true<CR>', { desc = 'LSP References / Definitions / ... (Trouble)' })
map('n', '<leader>td', '<cmd>Trouble diagnostics toggle focus=true<CR>', { desc = '[T]rouble [D]iagnostics' })
map('n', '<leader>tb', '<cmd>Trouble diagnostics toggle filter.buf=0 focus=true<CR>', { desc = '[T]rouble [B]uffer Diagnostics' })
map('n', '<leader>ts', '<cmd>Trouble symbols toggle focus=false<CR>', { desc = '[T]rouble [S]ymbols' })
-- map('n', '<leader>tf', '<cmd>Trouble lsp toggle focus=true win.position=right<CR>', { desc = 'LSP Definitions / references / ... (Trouble)' })
-- map('n', '<leader>tt', '<cmd>TodoTrouble<CR>', { desc = '[T]rouble [T]odo' }) -- Using telescope for this already

-- These 2 bindings are currently replaced by Trouble.nvim (idk might use them again in the future)

-- Add current buffer diagnostics to location list with severity WARN or higher.
-- map('n', '<leader>dl', function()
--   vim.diagnostic.setloclist { severity = { min = vim.diagnostic.severity.WARN } }
-- end, { desc = '[D]iagnostics [L]oclist' })

-- Add all buffer diagnostics to qflist with severity WARN or higher.
-- map('n', '<leader>dq', function()
--   vim.diagnostic.setqflist { severity = { min = vim.diagnostic.severity.WARN } }
-- end, { desc = '[D]iagnostics [Q]uickfix' })

-- Telescope
map(
    'n',
    '<leader>fL',
    '<cmd>lua require("telescope.builtin").find_files({ search_dirs = { vim.fn.getcwd(), "packages/types/src" } })<cr>',
    { desc = 'Find Files in Search Dirs' }
)
map('n', '<leader>fl', '<cmd>Telescope find_files<cr>', { desc = 'Find [F]i[L]es' })
map('n', '<leader>fa', '<cmd>Telescope find_files follow=true no_ignore=true hidden=true<CR>', { desc = '[F]ind [A]ll Files' })
map('n', '<leader>fd', '<cmd>Telescope diagnostics<cr>', { desc = '[F]ind [D]iagnostics' })
map('n', '<leader>fs', '<cmd>Telescope grep_string<cr>', { desc = '[F]ind Current [S]tring' })
map('n', '<leader>fz', '<cmd>Telescope current_buffer_fuzzy_find<CR>', { desc = '[F]ind Curr Buf Fu[ZZ]y' })
map('n', '<leader>fp', '<cmd>Telescope buffers<cr>', { desc = '[F]ind Buffers in [Project]' })
map('n', '<leader>fo', '<cmd>Telescope recent_files workspace=CWD<cr>', { desc = 'Recent files' }) -- better builtin.oldfiles
map('n', '<leader>fw', ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>", { desc = 'Find Words' }) -- better builtin.live_grep (can pass ripgrep args)
map('n', '<leader>fr', '<cmd>Telescope frecency workspace=CWD<cr>', { desc = '[F]ind Buffers in [Project]' }) -- uses mozilla's frecency algorithm
map('n', '<leader>fS', '<cmd>Telescope luasnip<CR>', { desc = '[F]ind [S]nippets' })
map('n', '<leader>ft', '<cmd>TodoTelescope keywords=TODO,FIX,BUG,NOTE<CR>', { desc = '[F]ind [T]odo' })

-- Telescope docs/help/infos
map('n', '<leader>fn', '<cmd>Telescope notify<cr>', { desc = '[F]ind [N]otif History' })
map('n', '<leader>fk', '<cmd>Telescope keymaps<cr>', { desc = '[F]ind [K]eymaps' })
map('n', '<leader>fb', '<cmd>Telescope builtin<cr>', { desc = '[F]ind [B]uiltins' })
map('n', '<leader>fh', '<cmd>Telescope help_tags<CR>', { desc = '[F]ind [H]elp Page' })
map('n', '<leader>fc', '<cmd>Telescope commands<CR>', { desc = '[F]ind Telescope [C]ommands' })

-- Quick edit for nvim config
map('n', '<leader>fe', '<cmd>lua require("telescope.builtin").find_files { cwd = vim.fn.stdpath("config") }<cr>', { desc = '[F]ind & [E]dit Nvim Conf' })

-- Telescope git
map('n', '<leader>cm', '<cmd>Telescope git_commits<CR>', { desc = 'telescope git commits' })
map('n', '<leader>gt', '<cmd>Telescope git_status<CR>', { desc = 'telescope git status' })

local diag = vim.diagnostic
local sev = diag.severity

-- LSP's
map('n', 'gd', '<cmd>Telescope lsp_definitions<CR>', { desc = '[G]oto [D]efinition' })
map('n', 'grn', vim.lsp.buf.rename, { desc = 'LSP [R]e[n]ame' })
map('n', 'grr', '<cmd>Telescope lsp_references<CR>', { desc = '[L]sp [R]eferences' })
-- map('n', 'grr', vim.lsp.buf.references, { desc = 'LSP [R]eferences' })
map('n', 'grt', '<cmd>Telescope lsp_type_definitions<CR>', { desc = '[G]oto [T]ype Def' })
map('n', 'gri', '<cmd>Telescope lsp_implementations<CR>', { desc = '[G]oto [I]mplementation' })
map('n', 'gD', vim.lsp.buf.declaration, { desc = 'LSP [G]oto [D]eclaration' })
map('n', 'ga', vim.lsp.buf.code_action, { desc = 'Code Action' })

map('n', 'gs', vim.lsp.buf.signature_help, { desc = '[S]ignature Help' })
map('n', 'gS', '<cmd>Telescope lsp_document_symbols<CR>', { desc = 'Doc [S]ymbols' })
map('n', 'grw', '<cmd>Telescope lsp_workspace_symbols<CR>', { desc = '[W]orkspace Symbols' })
map('n', 'grd', '<cmd>Telescope lsp_dynamic_workspace_symbols<CR>', { desc = '[D]ynamic Workspace Symbols' })

map('n', 'glr', '<cmd>LspRestart<cr>')
map('n', 'gli', '<cmd>LspInfo<cr>')

-- Lsp workspace dir
map('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, { desc = 'Add workspace dir' })
map('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, { desc = 'Remove workspace dir' })
map('n', '<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
end, { desc = 'List workspace folders' })

-- Warnings
map('n', '<M-w>', function()
    diag.jump { count = 1, severity = sev.WARN, float = true }
end, { desc = 'Next warning diagnostic' })

map('n', '<M-W>', function()
    diag.jump { count = -1, severity = sev.WARN, float = true }
end, { desc = 'Previous warning diagnostic' })

-- Errors
map('n', '<M-n>', function()
    diag.jump { count = 1, severity = sev.ERROR, float = true }
end, { desc = 'Next error diagnostic' })

map('n', '<M-N>', function()
    diag.jump { count = -1, severity = sev.ERROR, float = true }
end, { desc = 'Previous error diagnostic' })

-- Hints
map('n', '<M-h>', function()
    diag.jump { count = 1, severity = sev.HINT, float = true }
end, { desc = 'Next hint diagnostic' })

map('n', '<M-H>', function()
    diag.jump { count = -1, severity = sev.HINT, float = true }
end, { desc = 'Previous hint diagnostic' })

-- Next/prev
map('n', ']d', function()
    diag.jump { count = 1, float = true }
end, { desc = 'Go to [N]ext diagnostic' })

map('n', '[d', function()
    diag.jump { count = -1, float = true }
end, { desc = 'Go to [P]rev diagnostic' })

map('n', '<M-d>', vim.diagnostic.open_float, { desc = '[D]iagnostic Open Current Line [F]loat' })
map('n', '<M-t>', function()
    vim.diagnostic.config { virtual_text = not vim.diagnostic.config().virtual_text }
end, { desc = '[T]oggle [D]iagnostics Text' })
