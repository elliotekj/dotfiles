vim.api.nvim_create_autocmd(
  { "BufEnter", "WinEnter", "VimResized" }, -- Events
  {
    pattern = { "*" },                    -- Patterns
    callback = function()
      vim.opt.scrolloff = math.floor(vim.api.nvim_win_get_height(0) / 2)
    end,
  }
)

vim.api.nvim_create_autocmd(
  { "BufEnter" },             -- Events
  {
    pattern = { "toggleterm" }, -- Patterns for toggleterm buffers
    command = "startinsert",  -- Start insert mode when entering terminal
  }
)
