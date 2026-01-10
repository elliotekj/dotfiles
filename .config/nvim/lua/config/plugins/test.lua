-- Based on https://github.com/harrisoncramer/nvim/blob/main/lua/plugins/neotest.lua

return {
  "jfpedroza/neotest-elixir",
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "jfpedroza/neotest-elixir",
    },
    config = function()
      local neotest = require("neotest")

      require("neotest").setup({
        adapters = {
          require('neotest-elixir'),
        }
      })

      vim.keymap.set(
        "n",
        "<leader>tv",
        function()
          neotest.run.run(vim.fn.expand("%"))
        end
      )

      vim.keymap.set(
        "n",
        "<leader>tt",
        function()
          neotest.run.run()
          neotest.summary.open()
        end
      )

      vim.keymap.set(
        "n",
        "<leader>to",
        function()
          neotest.output.open({ last_run = true, enter = true })
        end
      )

      vim.keymap.set(
        "n",
        "<leader>tr",
        function()
          neotest.run.run_last({ enter = true })
          neotest.output.open({ last_run = true, enter = true })
        end
      )

      vim.keymap.set(
        "n",
        "<leader>ts",
        function()
          neotest.summary.close()
        end
      )
    end
  }
}
