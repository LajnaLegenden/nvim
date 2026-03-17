return {
  {
    'sindrets/diffview.nvim',
    event = 'VeryLazy',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { 'nvim-tree/nvim-web-devicons', optional = true },
    },

    -- Keymaps
    keys = function()
      -- Detect default branch (main/master)
      local function default_branch()
        local handle = io.popen 'git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null'
        if handle then
          local result = handle:read '*a'
          handle:close()
          local branch = result:match 'refs/remotes/origin/(.+)'
          if branch then
            return branch:gsub('%s+', '')
          end
        end
        return 'main' -- fallback
      end

      return {
        -- Diff index (working tree vs index)
        { '<leader>vi', '<cmd>DiffviewOpen<cr>', desc = 'Diff: Index' },

        -- Diff against default branch
        {
          '<leader>vm',
          function()
            vim.cmd('DiffviewOpen ' .. default_branch())
          end,
          desc = 'Diff: Default branch',
        },

        -- Full branch comparison (default...HEAD)
        {
          '<leader>vM',
          function()
            vim.cmd('DiffviewOpen ' .. default_branch() .. '...HEAD')
          end,
          desc = 'Diff: Default...HEAD',
        },

        -- Diff current file vs index
        { '<leader>vf', '<cmd>DiffviewOpen -- %<cr>', desc = 'Diff: File (index)' },

        -- Diff current file vs default branch
        {
          '<leader>vF',
          function()
            vim.cmd('DiffviewOpen ' .. default_branch() .. ' -- %')
          end,
          desc = 'Diff: File vs default',
        },

        -- Repo history
        { '<leader>vh', '<cmd>DiffviewFileHistory<cr>', desc = 'History: Repo' },

        -- Current file history
        { '<leader>vH', '<cmd>DiffviewFileHistory %<cr>', desc = 'History: File' },

        -- Close diffview
        { '<leader>vc', '<cmd>DiffviewClose<cr>', desc = 'Diff: Close' },
      }
    end,

    config = function()
      require('diffview').setup {
        enhanced_diff_hl = true,

        view = {
          default = {
            layout = 'diff2_horizontal',
          },
          merge_tool = {
            layout = 'diff3_horizontal',
          },
        },

        file_panel = {
          listing_style = 'tree',
          tree_options = {
            flatten_dirs = true,
            folder_statuses = 'only_folded',
          },
        },

        hooks = {
          diff_buf_read = function()
            vim.opt_local.wrap = false
            vim.opt_local.list = false
            vim.opt_local.colorcolumn = '100'
          end,
        },
      }
    end,
  },
}
