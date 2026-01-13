return {
  'jfpedroza/neotest-elixir',
  {
    'nvim-neotest/neotest',
    dependencies = {
      'nvim-neotest/nvim-nio',
      'nvim-lua/plenary.nvim',
      'antoinemadec/FixCursorHold.nvim',
      'nvim-treesitter/nvim-treesitter',
      'jfpedroza/neotest-elixir',
    },
    config = function()
      local neotest = require('neotest')

      neotest.setup({
        adapters = {
          require('neotest-elixir'),
        },
      })

      vim.keymap.set('n', '<leader>tv', function()
        neotest.run.run(vim.fn.expand('%'))
      end, { desc = 'Test file' })

      vim.keymap.set('n', '<leader>tt', function()
        neotest.run.run()
        neotest.summary.open()
      end, { desc = 'Test nearest' })

      vim.keymap.set('n', '<leader>to', function()
        neotest.output.open({ last_run = true, enter = true })
      end, { desc = 'Test output' })

      vim.keymap.set('n', '<leader>tr', function()
        neotest.run.run_last({ enter = true })
        neotest.output.open({ last_run = true, enter = true })
      end, { desc = 'Rerun last test' })

      vim.keymap.set('n', '<leader>ts', neotest.summary.close, { desc = 'Close test summary' })
    end,
  },
}
