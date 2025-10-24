-- Add custom LSP server
local lspconfig = require 'lspconfig'

require('lspconfig.configs').amendLsp = {
  default_config = {
    cmd = { 'amend-lsp', '--stdio' },
    filetypes = { 'javascript', 'typescript' },
    root_dir = function(fname)
      return require('lspconfig.util').root_pattern('package.json', 'tsconfig.json', '.git')(fname) or vim.fn.getcwd()
    end,
    settings = {},
  },
}

lspconfig.amendLsp.setup {}
print 'Setting up amend lsp'
