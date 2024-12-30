return {
  'mhinz/vim-startify',
  -- {
  --   'ellisonleao/gruvbox.nvim',
  --   config = function()
  --     require('gruvbox').setup({
  --       terminal_colors = true,
  --       undercurl = false,
  --       underline = false,
  --       bold = false,
  --       italic = {
  --         strings = false,
  --         emphasis = true,
  --         comments = true,
  --         operators = false,
  --         folds = true,
  --       },
  --       strikethrough = false,
  --       contrast = '', -- can be "hard", "soft" or empty string
  --     })
  --     vim.cmd('colorscheme gruvbox')
  --   end,
  -- },
  {
    "oxfist/night-owl.nvim",
    lazy = false, 
    priority = 1000,
    config = function()
      require("night-owl").setup()
      vim.opt.termguicolors = true
      vim.cmd.colorscheme("night-owl")

      vim.cmd([[
        hi NeogitDiffAddHighlight    guibg=NONE guifg=#9ccc65
        hi NeogitDiffDeleteHighlight guibg=NONE guifg=#ef5350
        hi NeogitDiffChangeHighlight guibg=NONE guifg=#e2b93d
        hi NeogitDiffContextHighlight guibg=NONE guifg=#d6deeb
        "hi NeogitHunkHeaderHighlight guibg=#3B4252 guifg=#D8DEE9
        "hi NeogitHunkHeader guibg=#2E3440 guifg=#81A1C1
      ]])
    end,
  },
  {
    'nvim-lualine/lualine.nvim',
    config = function()
      -- don't show `-- INSERT --` since we have a fancy status line
      vim.opt.showmode = false

      -- By default the gruvbox theme uses cyan for insert and green for command but I'm so
      -- used to it being the opposite...
      -- local gruvbox = require('lualine.themes.gruvbox')
      -- gruvbox.command.a.bg, gruvbox.insert.a.bg = gruvbox.insert.a.bg, gruvbox.command.a.bg
      -- Also some components in the middle change color between modes which is annoying.
      -- I only every want the mode component to change color when switching mode...
      -- gruvbox.insert.c.bg = gruvbox.normal.c.bg
      -- gruvbox.insert.c.fg = gruvbox.normal.c.fg
      -- gruvbox.visual.c.bg = gruvbox.normal.c.bg
      -- gruvbox.visual.c.fg = gruvbox.normal.c.fg
      -- gruvbox.replace.c.bg = gruvbox.normal.c.bg
      -- gruvbox.replace.c.fg = gruvbox.normal.c.fg
      -- gruvbox.command.c.bg = gruvbox.normal.c.bg
      -- gruvbox.command.c.fg = gruvbox.normal.c.fg

      require('lualine').setup({
        options = {
          icons_enabled = false,
          -- theme = gruvbox,
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
