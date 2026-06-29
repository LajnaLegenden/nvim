return {
  { 'ellisonleao/gruvbox.nvim', priority = 1000, config = true },
  { -- You can easily change to a different colorscheme.
    -- Change the name of the colorscheme plugin below, and then

    -- change the command in the config to whatever the name of that colorscheme is.
    --
    -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
    'olimorris/onedarkpro.nvim',
    priority = 1000, -- Make sure to load this before all the other start plugins.
    config = function()
      vim.cmd.colorscheme 'onedark_vivid'
    end,
  },
  {
    'navarasu/onedark.nvim',
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      require('onedark').setup {
        style = 'warmer',
      }
      require('onedark').load()
    end,
  },
  {
    'navarasu/onedark.nvim',
    name = 'onedark-navarasu',
    priority = 1000,
    config = function()
      require('onedark').setup {
        style = 'deep', -- try: dark, darker, cool, deep, warm, warmer, light
      }
      -- vim.cmd.colorscheme("onedark")
    end,
  },

  {
    'EdenEast/nightfox.nvim',
    priority = 1000,
    config = function()
      -- try: nightfox, carbonfox, duskfox, terafox
      -- vim.cmd.colorscheme("carbonfox")
    end,
  },

  {
    'folke/tokyonight.nvim',
    priority = 1000,
    opts = {
      style = 'storm', -- try: storm, night, moon
    },
    config = function(_, opts)
      require('tokyonight').setup(opts)
      -- vim.cmd.colorscheme("tokyonight-storm")
    end,
  },

  {
    'rebelot/kanagawa.nvim',
    priority = 1000,
    config = function()
      -- vim.cmd.colorscheme("kanagawa-wave")
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
--
