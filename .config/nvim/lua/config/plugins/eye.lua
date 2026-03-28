return {
  {
    dir = '~/dev/eye',
    name = 'eye.nvim',
    config = function()
      local eye = require('eye')

      eye.setup()

      vim.keymap.set('n', '<leader>rs', eye.start, { desc = 'Start review' })
      vim.keymap.set('n', '<leader>rq', eye.stop, { desc = 'Stop review' })
      vim.keymap.set('v', '<leader>rc', eye.comment, { desc = 'Add review comment' })
      vim.keymap.set('n', '<leader>rc', eye.comment, { desc = 'Edit review comment' })

      local function comment_or_start(mode)
        return function()
          if eye.is_active() then
            eye.comment()
          else
            eye.start()
          end
        end
      end

      vim.keymap.set('v', '<leader>rr', comment_or_start('v'), { desc = 'Review: add comment (starts review if needed)' })
      vim.keymap.set('n', '<leader>rr', comment_or_start('n'), { desc = 'Review: edit comment (starts review if needed)' })
      vim.keymap.set('n', '<leader>ry', eye.export, { desc = 'Copy review to clipboard' })
      vim.keymap.set('n', ']r', eye.next_change, { desc = 'Next change' })
      vim.keymap.set('n', '[r', eye.prev_change, { desc = 'Previous change' })
      vim.keymap.set('x', 'ir', eye.select_change, { desc = 'Inner review block' })
    end,
  },
}
