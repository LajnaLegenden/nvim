-- ESLint via the official vscode-eslint language server (bundled with the plugin,
-- runs on `node`, no Mason). Provides LSP diagnostics + fix-on-save.
-- Replaces the eslint_d wiring that used to live in lint.lua and conform.lua.

local FILETYPES = {
  'javascript',
  'javascriptreact',
  'javascript.jsx',
  'typescript',
  'typescriptreact',
  'typescript.tsx',
  'vue',
  'svelte',
  'astro',
}

return {
  'esmuellert/nvim-eslint',
  ft = FILETYPES,
  config = function()
    local eslint = require 'nvim-eslint' -- == nvim-eslint.client
    local settings = require 'nvim-eslint.settings'

    -- Only run eslint when the project actually uses it, and step aside when
    -- biome (an all-in-one lint+format tool that replaces eslint) owns the project.
    -- ponytail: prettier/dprint are pure formatters and coexist with eslint, so
    -- they don't disable it; add their config names here if you want them to.
    local function should_enable(bufnr)
      if not settings.resolve_eslint_config_dir(bufnr) then
        return false
      end
      if vim.fs.root(bufnr, { 'biome.json', 'biome.jsonc' }) then
        return false
      end
      return true
    end

    -- ponytail: nvim-eslint has no per-buffer gate — setup() registers an
    -- unconditional FileType autostart. We let setup() apply its config, then
    -- delete just the autocmd it added and drive start ourselves via should_enable.
    local function filetype_autocmd_ids()
      local ids = {}
      for _, a in ipairs(vim.api.nvim_get_autocmds { event = 'FileType' }) do
        -- built-in Vimscript autocmds (filetypeplugin/indent, syntaxset) have no id
        if a.id then
          ids[a.id] = true
        end
      end
      return ids
    end
    local before = filetype_autocmd_ids()

    eslint.setup {
      settings = {
        -- monorepo: run eslint from the file's own package, not the git root,
        -- so each package resolves its own config/plugins.
        workingDirectory = function(bufnr)
          local pkg = vim.fs.root(bufnr, { 'package.json' })
          return pkg and { directory = pkg } or { mode = 'location' }
        end,
      },
    }

    for _, a in ipairs(vim.api.nvim_get_autocmds { event = 'FileType' }) do
      if a.id and not before[a.id] then
        vim.api.nvim_del_autocmd(a.id)
      end
    end

    local grp = vim.api.nvim_create_augroup('nvim-eslint-gated', { clear = true })
    vim.api.nvim_create_autocmd('FileType', {
      group = grp,
      pattern = FILETYPES,
      callback = function(args)
        if should_enable(args.buf) then
          eslint.start_client_for_buffer(args.buf)
        end
      end,
    })

    -- We were lazy-loaded on `ft`, so the FileType event for the current buffer
    -- already fired before the autocmd above existed. Start it explicitly.
    -- (vim.lsp.start dedups, so a double-start is a harmless no-op.)
    if should_enable(0) then
      eslint.start_client_for_buffer(vim.api.nvim_get_current_buf())
    end

    -- Fix-on-save: apply `eslint --fix` (LSP applyAllFixes) synchronously before
    -- the write, only for buffers with the eslint client attached. Runs alongside
    -- conform's format-on-save; reorder if eslint and prettier fight over style.
    vim.api.nvim_create_autocmd('BufWritePre', {
      group = grp,
      callback = function(args)
        local clients = vim.lsp.get_clients { bufnr = args.buf, name = 'eslint' }
        if #clients == 0 then
          return
        end
        clients[1]:request_sync('workspace/executeCommand', {
          command = 'eslint.applyAllFixes',
          arguments = { { uri = vim.uri_from_bufnr(args.buf), version = vim.lsp.util.buf_versions[args.buf] } },
        }, 1000, args.buf)
      end,
    })
  end,
}
