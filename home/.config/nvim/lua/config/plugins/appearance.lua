return {
  'mhinz/vim-startify',
  'blazkowolf/gruber-darker.nvim',
  {
    'nvim-lualine/lualine.nvim',
    config = function()
      vim.opt.showmode = false

      local function buffer_offset()
        local byte_offset = vim.fn.line2byte(vim.fn.line('.')) + vim.fn.col('.') - 1
        if byte_offset < 0 then
          byte_offset = 0
        end
        return byte_offset
      end

      require('lualine').setup({
        options = {
          icons_enabled = false,
          component_separators = { left = '', right = '' },
          section_separators = { left = '', right = '' },
        },
        sections = {
          lualine_a = { 'mode' },
          lualine_b = { 'branch' },
          lualine_c = { 'filename' },
          lualine_x = { 'diagnostics', 'encoding', 'fileformat', 'filetype' },
          lualine_y = { 'progress', buffer_offset },
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
  'arnamak/stay-centered.nvim',
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = function(_, opts)
      return require("indent-rainbowline").make_opts(opts)
    end,
    dependencies = {
      "TheGLander/indent-rainbowline.nvim",
    },
    keys = {
      { "<localleader>ti", "<cmd>IBLToggle<cr>", desc = "Toggle indent lines" },
    },
  },
  {
    "utilyre/barbecue.nvim",
    name = "barbecue",
    version = "*",
    dependencies = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons", -- optional dependency
    }
  }
}
