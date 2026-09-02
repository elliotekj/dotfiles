local function find_local_base_branch()
  for _, branch in ipairs({ 'main', 'master' }) do
    local result = vim.system({
      'git',
      'show-ref',
      '--verify',
      '--quiet',
      'refs/heads/' .. branch,
    }, { text = true }):wait()

    if result.code == 0 then
      return branch
    end
  end
end

return {
  {
    'NeogitOrg/neogit',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'sindrets/diffview.nvim',
      'nvim-telescope/telescope.nvim',
    },
    config = true,
  },
  {
    'lewis6991/gitsigns.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    keys = {
      {
        '<leader>gs',
        function()
          require('gitsigns').stage_buffer()
        end,
        mode = 'n',
        desc = 'Stage File',
      },
      {
        '<leader>gs',
        function()
          local start_line = vim.fn.line('.')
          local end_line = vim.fn.line('v')

          if start_line > end_line then
            start_line, end_line = end_line, start_line
          end

          require('gitsigns').stage_hunk({ start_line, end_line })
        end,
        mode = 'v',
        desc = 'Stage Selection',
      },
      {
        '<leader>gb',
        function()
          require('gitsigns').toggle_current_line_blame()
        end,
        mode = 'n',
        desc = 'Toggle Inline Blame',
      },
      {
        '<localleader>rb',
        function()
          local base_branch = find_local_base_branch()
          if not base_branch then
            vim.notify('No local main or master branch found', vim.log.levels.WARN)
            return
          end

          local merge_base_result = vim.system({
            'git',
            'merge-base',
            base_branch,
            'HEAD',
          }, { text = true }):wait()
          if merge_base_result.code ~= 0 then
            vim.notify('Could not determine the branch merge base', vim.log.levels.WARN)
            return
          end

          local merge_base = vim.trim(merge_base_result.stdout or '')
          local gitsigns = require('gitsigns')
          gitsigns.change_base(merge_base, true, function(err)
            vim.schedule(function()
              if err then
                vim.notify('Could not configure branch review: ' .. err, vim.log.levels.ERROR)
                return
              end

              gitsigns.toggle_deleted(true)
              gitsigns.setqflist('all', { open = true })
              vim.notify('Reviewing branch changes against local ' .. base_branch, vim.log.levels.INFO)
            end)
          end)
        end,
        mode = 'n',
        desc = 'Review branch hunks in local buffers',
      },
      {
        '<leader>gp',
        function()
          require('gitsigns').preview_hunk_inline()
        end,
        mode = 'n',
        desc = 'Preview current branch hunk inline',
      },
      {
        '<localleader>td',
        function()
          require('gitsigns').toggle_deleted()
        end,
        mode = 'n',
        desc = 'Toggle deleted lines inline',
      },
    },
    opts = {
      attach_to_untracked = true,
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end

        map('n', ']h', gs.next_hunk, 'Next Hunk')
        map('n', '[h', gs.prev_hunk, 'Prev Hunk')
      end,
    }
  },
  {
    'sindrets/diffview.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('diffview').setup()

      vim.keymap.set('n', '<leader>gd', function()
        local base_branch = find_local_base_branch()
        if not base_branch then
          vim.notify('No local main or master branch found', vim.log.levels.WARN)
          return
        end

        vim.cmd('DiffviewOpen ' .. base_branch)
      end, { desc = 'Diff worktree against local main/master' })
    end,
  },
}
