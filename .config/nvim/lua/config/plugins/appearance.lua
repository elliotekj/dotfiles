local function buffer_offset()
  local offset = vim.fn.line2byte(vim.fn.line('.')) + vim.fn.col('.') - 1
  return math.max(offset, 0)
end

return {
  {
    'sainnhe/everforest',
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.everforest_background = 'medium'
      vim.g.everforest_colors_override = { bg0 = { '#232A2E', '233' } }
      vim.g.everforest_better_performance = 1
      vim.o.background = 'dark'
      vim.cmd.colorscheme('everforest')
    end,
  },
  {
    'nvim-lualine/lualine.nvim',
    config = function()
      vim.opt.showmode = false

      require('lualine').setup({
        options = {
          icons_enabled = false,
          component_separators = { left = '', right = '' },
          section_separators = { left = '', right = '' },
          theme = 'everforest'
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
  {
    'arnamak/stay-centered.nvim',
    config = function()
      local stay_centered = require('stay-centered')
      stay_centered.setup()

      local disable_ft = {
        DiffviewFiles = true,
        DiffviewFilePanel = true,
        DiffviewFileHistoryPanel = true,
      }

      vim.api.nvim_create_autocmd('FileType', {
        callback = function(args)
          if disable_ft[vim.bo[args.buf].filetype] then
            stay_centered.disable()
          end
        end,
      })

      vim.api.nvim_create_autocmd('BufWinLeave', {
        callback = function(args)
          if disable_ft[vim.bo[args.buf].filetype] then
            stay_centered.enable()
          end
        end,
      })
    end,
  },
  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    event = 'BufReadPost',
    opts = {
      enabled = false,
    },
    keys = {
      { '<localleader>ti', '<cmd>IBLToggle<cr>', desc = 'Toggle indent lines' },
    },
  },
}
