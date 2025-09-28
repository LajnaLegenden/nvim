return {
  { -- Autoformat
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>lf',
        function()
          require('conform').format { async = true, lsp_format = 'fallback' }
        end,
        mode = '',
        desc = '[L]ocal [F]ormat buffer',
      },
    },
    config = function()
      require('conform').setup({
        notify_on_error = true,
        format_on_save = function(bufnr)
          -- Disable "format_on_save lsp_fallback" for languages that don't
          -- have a well standardized coding style. You can add additional
          -- languages here or re-enable it for the disabled ones.
          local disable_filetypes = { c = true, cpp = true }
          if disable_filetypes[vim.bo[bufnr].filetype] then
            return nil
          else
            print("Formatting buffer")
            return {
              timeout_ms = 1500,
              lsp_format = 'fallback',
            }
          end
        end,
        formatters = {
          shfmt = {
            prepend_args = { "-i", "2" },
          },
          eslint_d = {
            require_cwd = true,
            ignore_stderr = true, -- ✅ only show stdout, suppress eslint warnings

            cwd = require("conform.util").root_file({
                ".eslintrc",
                ".eslintrc.json",
                ".eslintrc.js",
                ".eslintrc.cjs",
                ".eslintrc.yaml",
                ".eslintrc.yml",
                "eslint.config.js",
                "eslint.config.mjs",
                "eslint.config.cjs",
              }),
          },
          
          prettier = {
            require_cwd = true,
            cwd = require("conform.util").root_file({
                ".prettierrc",
                ".prettierrc.json",
                ".prettierrc.js",
                ".prettierrc.cjs",
                ".prettierrc.yaml",
                ".prettierrc.yml",
                ".prettierrc.json5",
                ".prettierrc.mjs",
                ".prettierrc.toml",
                "prettier.config.js",
                "prettier.config.cjs",
                "prettier.config.mjs",
                })
            },
          biome = {
            require_cwd = true,
            cwd = require("conform.util").root_file({
                "biome.json",
                "biome.jsonc",
              })
          },
        },
        formatters_by_ft = {
          lua = { "stylua" },
          python = { "isort", "black" },
          javascript = { "eslint_d", "prettier", "biome" },
          typescript = { "eslint_d", "prettier", "biome" },
          javascriptreact = { "eslint_d", "prettier", "biome" },
          typescriptreact = { "eslint_d", "prettier", "biome" },
          json = { "prettier", "biome" },
          jsonc = { "prettier", "biome" },
          css = { "prettier", "biome" },
          scss = { "prettier", "biome" },
          html = { "prettier", "biome" },
          markdown = { "prettier", "biome" },
        },
      })
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
