return {
  {
    'obsidian-nvim/obsidian.nvim',
    version = '*',
    lazy = false,

    keys = {
      { '<leader>fn', '<cmd>Obsidian search<cr>', desc = 'Search notes' },
    },
    opts = {
      legacy_commands = false,
      workspaces = {
        {
          name = 'personal',
          path = '~/Library/Mobile Documents/iCloud~md~obsidian/Documents/Elliot',
        },
      },
      picker = {
        name = 'telescope.nvim',
      },
      completion = {
        nvim_cmp = true,
      },
    },
  },
}
