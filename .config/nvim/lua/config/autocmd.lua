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

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'markdown',
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.colorcolumn = '79'
    vim.cmd('Wrapwidth 79')
    vim.keymap.set('n', '<localleader>tw', function()
      if vim.b.wrapwidth then
        vim.cmd('Wrapwidth 0')
      else
        vim.cmd('Wrapwidth 79')
      end
    end, { buffer = true, desc = 'Toggle markdown wrapping' })
  end,
})
