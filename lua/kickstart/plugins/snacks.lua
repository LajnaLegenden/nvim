return {
  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    opts = {
      picker = {
        enabled = true,
        sources = {
          files = {
            matcher = {
              frecency = true,
            },
          },
        },
        ui_select = true,
      },
    },
    keys = {
      {
        '<leader>fh',
        function()
          Snacks.picker.help()
        end,
        desc = '[F]ind [H]elp',
      },
      {
        '\\',
        function()
          Snacks.explorer.reveal()
        end,
        desc = 'Explorer reveal',
        silent = true,
      },
      {
        '<leader>fk',
        function()
          Snacks.picker.keymaps()
        end,
        desc = '[F]ind [K]eymaps',
      },
      {
        '<leader>ff',
        function()
          Snacks.picker.files()
        end,
        desc = '[F]ind [F]iles',
      },
      {
        '<leader>fs',
        function()
          Snacks.picker.pickers()
        end,
        desc = '[F]ind [S]elect Picker',
      },
      {
        '<leader>fw',
        function()
          Snacks.picker.grep_word()
        end,
        desc = '[F]ind current [W]ord',
      },
      {
        '<leader>fg',
        function()
          Snacks.picker.grep()
        end,
        desc = '[F]ind by [G]rep',
      },
      {
        '<leader>fd',
        function()
          Snacks.picker.diagnostics()
        end,
        desc = '[F]ind [D]iagnostics',
      },
      {
        '<leader>fr',
        function()
          Snacks.picker.resume()
        end,
        desc = '[F]ind [R]esume',
      },
      {
        '<leader>f.',
        function()
          Snacks.picker.recent()
        end,
        desc = '[F]ind Recent Files ("." for repeat)',
      },
      {
        '<leader><leader>',
        function()
          Snacks.picker.smart {
            layout = {
              preset = 'dropdown',
              preview = false,
            },
          }
        end,
        desc = '[F]ind existing buffers',
      },

      -- Fuzzy search in current buffer
      {
        '<leader>/',
        function()
          Snacks.picker.lines {
            layout = {
              preset = 'dropdown',
            },
          }
        end,
        desc = '[/] Fuzzily search in current buffer',
      },

      -- Live grep in open buffers
      {
        '<leader>f/',
        function()
          Snacks.picker.grep_buffers {
            prompt = 'Live Grep in Open Files',
          }
        end,
        desc = '[F]ind [/] in Open Files',
      },

      -- Search word under cursor
      {
        '<leader>s',
        function()
          Snacks.picker.grep_word()
        end,
        desc = '[S]earch Word under cursor',
      },

      -- Search files using word under cursor
      {
        '<leader>d',
        function()
          Snacks.picker.files {
            pattern = vim.fn.expand '<cword>',
            prompt = 'Search Files with Word Under Cursor',
          }
        end,
        desc = 'Search Wor[d] in files',
      },

      -- Find related test file
      {
        '<leader>ft',
        function()
          local filename = vim.fn.expand '%:t:r'
          local results = vim.fn.systemlist {
            'rg',
            '--files',
            '--iglob',
            filename .. '-test.*',
            '--iglob',
            filename .. '.test.*',
          }

          if #results == 0 then
            vim.notify('No related test files found', vim.log.levels.INFO)
          elseif #results == 1 then
            vim.cmd.edit(results[1])
          else
            Snacks.picker.files {
              title = 'Find Related Test',
              finder = function()
                local items = {}
                for _, file in ipairs(results) do
                  items[#items + 1] = { text = file, file = file }
                end
                return items
              end,
              format = 'file',
              confirm = function(picker, item)
                picker:close()
                if item and item.file then
                  vim.cmd.edit(item.file)
                end
              end,
            }
          end
        end,
        desc = '[F]find [t]est file',
      },

      -- Search Neovim config
      {
        '<leader>fc',
        function()
          Snacks.picker.files { cwd = vim.fn.stdpath 'config' }
        end,
        desc = '[F]ind Neovim [c]onfig',
      },
    },
  },
}
