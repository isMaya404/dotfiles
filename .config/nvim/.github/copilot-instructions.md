# Copilot instructions for this Neovim config

## Build, test, and lint commands

- **Bootstrap/update plugins (and run plugin build hooks):** `nvim --headless "+Lazy! sync" "+qa"`
- **Format/Lint Lua config with Stylua (repo style):** `stylua --check init.lua lua`
- **Auto-fix Lua formatting:** `stylua init.lua lua`
- **Tests:** this repo currently has no runnable test suite configured (the neotest plugin block is present but commented out).
- **Single-test command:** not available in this repository right now.

## High-level architecture

- Entry point is `init.lua`. It bootstraps `lazy.nvim`, then loads one of two profiles:
  - **Native Neovim profile:** `plugins` + `custom.*`
  - **VSCode-neovim profile:** `vsc.plugins` + `vsc.*` (guarded by `vim.g.vscode`)
- Plugin specs are split across `lua/plugins/*.lua` (not just one file). Lazy imports the whole `plugins` namespace.
- Most plugin behavior is delegated to focused modules in `lua/configs/*` and loaded from each plugin’s `config` callback.
- LSP startup is intentionally delayed until a custom `User FilePost` event (`lua/custom/autocmds.lua`) to avoid eager startup before UI/buffer state is ready.
- `lua/configs/lsp/_lsp.lua` is the LSP orchestrator:
  - sets global diagnostic behavior,
  - configures `mason` + `mason-tool-installer`,
  - merges default capabilities,
  - enables per-server configs from `lua/configs/lsp/*.lua`.
- TypeScript/Deno split is explicit:
  - `vtsls` config avoids attaching in Deno roots,
  - `denols` config only attaches in Deno roots and includes virtual text-document handlers for `deno:` URIs.

## Key repository-specific conventions

- **Custom keyboard layout remap is foundational.** Core motions are remapped in `lua/custom/mappings/remap.lua` (and mirrored in `lua/vsc/mappings.lua`). Do not assume default `hjkl` semantics when adding mappings.
- **Use project autocommands pattern:** `augroup('idk_' .. name)` helper + clear groups, defined in `custom/autocmds.lua`/`vsc/autocmds.lua`.
- **Prefer lazy loading by event/cmd/keys** in plugin specs; avoid unconditional startup unless intentionally early (e.g., colorscheme).
- **Formatting/linting pipeline is editor-driven:**
  - `conform.nvim` handles format-on-save with per-filetype formatters (`lua/configs/conform.lua`),
  - `nvim-lint` runs `eslint_d` on JS/TS on `BufWritePost`, `BufEnter`, and `InsertLeave`.
- **VSCode mode constraints matter:** leader-based mappings are intentionally limited there; use `vscode.call(...)` integrations in `lua/vsc/mappings.lua`.
- **Tooling choices are centralized in LSP setup** (`_lsp.lua` + per-language files). Add or change language behavior there rather than scattering setup in unrelated files.
