return {
  {
    'vimwiki/vimwiki',
    init = function()
      vim.g.vimwiki_global_ext = 0
      vim.g.vimwiki_list = {
        {
          path = vim.fn.expand('~/.vimwiki/'),
          syntax = 'markdown',
          ext = '.md',
        },
      }
      vim.g.vimwiki_map_prefix = '<LocalLeader>w'
    end,
    config = function()
      vim.keymap.set('n', '<localleader>wt', '<cmd>VimwikiMakeDiaryNote<cr>', {
        desc = "Open today's diary",
      })

      local autosave_group = vim.api.nvim_create_augroup('VimwikiAutoSave', { clear = true })
      vim.api.nvim_create_autocmd({ 'InsertLeave', 'TextChanged' }, {
        group = autosave_group,
        callback = function(args)
          if vim.bo[args.buf].filetype == 'vimwiki' and vim.bo[args.buf].modified then
            vim.api.nvim_buf_call(args.buf, function()
              vim.cmd('silent update')
            end)
          end
        end,
      })
    end,
  },
}
