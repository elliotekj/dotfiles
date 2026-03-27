return {
  {
    'stevearc/conform.nvim',
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          lua = { "stylua" },
          elixir = { "mix" },
          python = { "isort", "black" },
          rust = { "rustfmt", lsp_format = "fallback" },
          javascript = { "prettierd", "prettier", stop_after_first = true },
          typescript = { "prettierd", "prettier", stop_after_first = true },
          typescriptreact = { "prettierd", "prettier", stop_after_first = true },
        },
      })

      vim.keymap.set('n', '<leader><leader>', function()
        require("conform").format({ timeout_ms = 500, lsp_format = "fallback" })
      end, { desc = 'Format file' })
    end,
  },
  {
    "cappyzawa/trim.nvim",
    opts = {
      trim_on_write = true
    }
  }
}
