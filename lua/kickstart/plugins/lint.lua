local function find_config_upward(config_files, tool_name)
  local current_file = vim.api.nvim_buf_get_name(0)
  local current_dir = vim.fn.fnamemodify(current_file, ':h')
  local cwd = vim.fn.getcwd()
  local found_files = {}
  local search_path = current_dir

  -- Search upward from current file directory to project root
  while search_path and (search_path == cwd or search_path:find(cwd, 1, true) == 1) do
    for _, config_file in ipairs(config_files) do
      local full_path = search_path .. '/' .. config_file
      local exists = vim.fn.filereadable(full_path) == 1

      if exists then
        local relative_path = search_path == cwd and config_file or vim.fn.fnamemodify(full_path, ':.')
        table.insert(found_files, relative_path)
      end
    end

    -- Move up one directory
    local parent = vim.fn.fnamemodify(search_path, ':h')
    if parent == search_path or parent == '/' then
      break
    end
    search_path = parent

    -- Stop if we've reached above the project root
    if not search_path:find(cwd, 1, true) then
      break
    end
  end

  return #found_files > 0, found_files
end

local function get_js_linters()
  local linters = {}

  -- Check for ESLint config
  local eslint_found, eslint_files = find_config_upward({
    '.eslintrc',
    '.eslintrc.json',
    '.eslintrc.js',
    '.eslintrc.cjs',
    '.eslintrc.yaml',
    '.eslintrc.yml',
    'eslint.config.js',
    'eslint.config.mjs',
    'eslint.config.cjs',
  }, 'ESLint')

  if eslint_found then
    table.insert(linters, 'eslint_d')
  end

  -- Check for Biome config
  local biome_found, biome_files = find_config_upward({
    'biome.json',
    'biome.jsonc',
  }, 'Biome')

  if biome_found then
    table.insert(linters, 'biomejs')
  end

  return linters
end

return {
  { -- Linting
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local lint = require 'lint'
      -- Set up linters by filetype
      lint.linters_by_ft = {
        javascript = get_js_linters(),
        typescript = get_js_linters(),
        javascriptreact = get_js_linters(),
        typescriptreact = get_js_linters(),
        markdown = { 'markdownlint' },
      }

      -- To allow other plugins to add linters to require('lint').linters_by_ft,
      -- instead set linters_by_ft like this:
      -- lint.linters_by_ft = lint.linters_by_ft or {}
      -- lint.linters_by_ft['markdown'] = { 'markdownlint' }
      --
      -- However, note that this will enable a set of default linters,
      -- which will cause errors unless these tools are available:
      -- {
      --   clojure = { "clj-kondo" },
      --   dockerfile = { "hadolint" },
      --   inko = { "inko" },
      --   janet = { "janet" },
      --   json = { "jsonlint" },
      --   markdown = { "vale" },
      --   rst = { "vale" },
      --   ruby = { "ruby" },
      --   terraform = { "tflint" },
      --   text = { "vale" }
      -- }
      --
      -- You can disable the default linters by setting their filetypes to nil:
      -- lint.linters_by_ft['clojure'] = nil
      -- lint.linters_by_ft['dockerfile'] = nil
      -- lint.linters_by_ft['inko'] = nil
      -- lint.linters_by_ft['janet'] = nil
      -- lint.linters_by_ft['json'] = nil
      -- lint.linters_by_ft['markdown'] = nil
      -- lint.linters_by_ft['rst'] = nil
      -- lint.linters_by_ft['ruby'] = nil
      -- lint.linters_by_ft['terraform'] = nil
      -- lint.linters_by_ft['text'] = nil

      -- Create autocommand which carries out the actual linting
      -- on the specified events.
      local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
        group = lint_augroup,
        callback = function()
          -- Only run the linter in buffers that you can modify in order to
          -- avoid superfluous noise, notably within the handy LSP pop-ups that
          -- describe the hovered symbol using Markdown.
          if vim.bo.modifiable then
            lint.try_lint()
          end
        end,
      })
    end,
  },
}
