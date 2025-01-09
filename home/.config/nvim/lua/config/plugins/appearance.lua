return {
  'mhinz/vim-startify',
  {
    "oxfist/night-owl.nvim",
    lazy = false,
    priority = 1000,
    config = true
  },
  {
    'nvim-lualine/lualine.nvim',
    config = function()
      vim.opt.showmode = false

      require('lualine').setup({
        options = {
          icons_enabled = false,
          theme = 'night-owl',
          component_separators = { left = '|', right = '|' },
          section_separators = { left = '', right = '' },
        },
        sections = {
          lualine_a = { 'mode' },
          lualine_b = { 'branch' },
          lualine_c = { 'filename' },
          lualine_x = { 'diagnostics', 'encoding', 'fileformat', 'filetype' },
          lualine_y = { 'progress' },
          lualine_z = { 'location' },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { 'filename' },
          lualine_x = { 'location' },
          lualine_y = {},
          lualine_z = {},
        },
        extensions = { 'quickfix' },
      })
    end,
  },
  'arnamak/stay-centered.nvim'
}
