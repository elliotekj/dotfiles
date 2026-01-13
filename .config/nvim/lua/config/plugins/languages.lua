return {
  {
    'rust-lang/rust.vim',
    ft = 'rust',
    config = function()
      -- we use conform to run rustfmt
      vim.g.rustfmt_autosave = 0
    end,
  },
  {
    'nvim-flutter/flutter-tools.nvim',
    lazy = false,
    dependencies = {
        'nvim-lua/plenary.nvim',
        'stevearc/dressing.nvim', -- optional for vim.ui.select
    },
    config = true,
  },
  {
    'fatih/vim-go',
    ft = 'go',
    config = function()
      -- we use nvim-lsp instead
      vim.g.go_gopls_enabled = 0
      vim.g.go_code_completion_enabled = 0
      vim.g.go_def_mapping_enabled = 0
      vim.g.go_diagnostics_enabled = 0
      vim.g.go_echo_go_info = 0
      vim.g.go_metalinter_enabled = 0
      -- we use conform to run gofmt
      vim.g.go_fmt_autosave = 0
    end,
  },
  { 'hashivim/vim-terraform', ft = 'terraform' },
  {
    "elixir-tools/elixir-tools.nvim",
    version = "*",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local elixir = require("elixir")
      local elixirls = require("elixir.elixirls")

      elixir.setup {
        nextls = { enable = false },
        elixirls = { enable = false },
        projectionist = {
          enable = true
        }
      }
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  }
}
