-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
-- Function to find Node.js >= 22 from fnm
local function find_node_from_fnm()
  local fnm_dir = vim.fn.expand '~/.local/share/fnm/node-versions'

  -- Check if fnm directory exists
  if vim.fn.isdirectory(fnm_dir) == 0 then
    return 'node' -- fallback to system node
  end

  -- Get all node versions from fnm
  local handle = vim.loop.fs_scandir(fnm_dir)
  if not handle then
    return 'node'
  end

  local versions = {}
  while true do
    local name, type = vim.loop.fs_scandir_next(handle)
    if not name then
      break
    end
    if type == 'directory' then
      -- Extract version number (format: v22.1.0 -> 22)
      local major = name:match '^v(%d+)'
      if major and tonumber(major) >= 22 then
        table.insert(versions, { name = name, major = tonumber(major) })
      end
    end
  end

  -- Sort by major version (descending) and return the highest
  if #versions > 0 then
    table.sort(versions, function(a, b)
      return a.major > b.major
    end)
    local node_path = fnm_dir .. '/' .. versions[1].name .. '/installation/bin/node'
    if vim.fn.executable(node_path) == 1 then
      return node_path
    end
  end

  return 'node' -- fallback
end

return {
  { 'gioele/vim-autoswap' },
  {
    'zbirenbaum/copilot.lua',
    dependencies = {
      'copilotlsp-nvim/copilot-lsp', -- (optional) for NES functionality
    },
    opts = {
      copilot_node_command = find_node_from_fnm(), -- Dynamically find Node.js >= 22 from fnm
    },
  },
  { 'nvim-mini/mini.ai', version = '*', opts = {} },
  { 'nvim-mini/mini.surround', version = '*', opts = {} },
  { 'nvim-mini/mini.splitjoin', version = '*', opts = {} },
  {
    'christoomey/vim-tmux-navigator',
    cmd = {
      'TmuxNavigateLeft',
      'TmuxNavigateDown',
      'TmuxNavigateUp',
      'TmuxNavigateRight',
      'TmuxNavigatePrevious',
      'TmuxNavigatorProcessList',
    },
    keys = {
      { '<c-h>', '<cmd><C-U>TmuxNavigateLeft<cr>' },
      { '<c-j>', '<cmd><C-U>TmuxNavigateDown<cr>' },
      { '<c-k>', '<cmd><C-U>TmuxNavigateUp<cr>' },
      { '<c-l>', '<cmd><C-U>TmuxNavigateRight<cr>' },
      { '<c-\\>', '<cmd><C-U>TmuxNavigatePrevious<cr>' },
    },
  },
  { 'kchmck/vim-coffee-script' },
  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    opts = {
      menu = {
        width = vim.api.nvim_win_get_width(0) - 4,
      },
      settings = {
        save_on_toggle = true,
      },
    },
    keys = function()
      local keys = {
        {
          '<leader>H',
          function()
            require('harpoon'):list():add()
          end,
          desc = 'Harpoon File',
        },
        {
          '<leader>h',
          function()
            local harpoon = require 'harpoon'
            harpoon.ui:toggle_quick_menu(harpoon:list())
          end,
          desc = 'Harpoon Quick Menu',
        },
      }

      for i = 1, 9 do
        table.insert(keys, {
          '<leader>' .. i,
          function()
            require('harpoon'):list():select(i)
          end,
          desc = 'Harpoon to File ' .. i,
        })
      end
      return keys
    end,
  },
  {
    'windwp/nvim-ts-autotag',
    opts = {},
  },
  {
    'nvim-mini/mini.nvim',
    version = false,
    config = function()
      local mini_files = require 'mini.files'

      -- OPTIONAL: basic defaults
      mini_files.setup()

      -- Keymap: <leader>fm = open file explorer
      vim.keymap.set('n', '<leader>fm', function()
        require('mini.files').open(vim.api.nvim_buf_get_name(0), false)
      end, { desc = 'Open MiniFiles explorer' })
    end,
  },
}
