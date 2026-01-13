vim.api.nvim_create_autocmd({ 'BufEnter', 'WinEnter', 'VimResized' }, {
  pattern = '*',
  callback = function()
    vim.opt.scrolloff = math.floor(vim.api.nvim_win_get_height(0) / 2)
  end,
})

vim.api.nvim_create_autocmd('BufEnter', {
  pattern = 'toggleterm',
  command = 'startinsert',
})
