return {
  {
    'NeogitOrg/neogit',
    lazy = true,
    dependencies = {
      'nvim-lua/plenary.nvim', -- required
      'sindrets/diffview.nvim',
      'folke/snacks.nvim', -- optional
    },
    cmd = 'Neogit',
    keys = {
      { '<leader>gg', '<cmd>Neogit<cr>', desc = 'Show Neogit UI' },
    },
  },
  {
    'LajnaLegenden/source-tree-nvim',
    cmd = {
      'SourceTree',
      'SourceTreeToggle',
      'SourceTreeRefresh',
    },
    keys = {
      {
        '<leader>gS',
        '<cmd>SourceTreeToggle<cr>',
        desc = 'Source Tree',
      },
    },
    opts = {
      side = 'left',
      width = 36,
      view = 'tree',
      log_limit = 50,
      -- toggle_key = "<leader>gS", -- omit when using `keys` above
    },
    config = function(_, opts)
      require('source-tree').setup(opts)
    end,
  },
}
