local function buffer_offset()
  local offset = vim.fn.line2byte(vim.fn.line('.')) + vim.fn.col('.') - 1
  return math.max(offset, 0)
end

return {
  {
    'projekt0n/github-nvim-theme',
    name = 'github-theme',
    lazy = false,
    priority = 1000,
    config = function()
      require('github-theme').setup({})

      vim.api.nvim_create_autocmd('ColorScheme', {
        callback = function()
          local groups = { 'Normal', 'NormalNC', 'NormalFloat', 'SignColumn', 'EndOfBuffer', 'FloatBorder' }
          for _, group in ipairs(groups) do
            local hl = vim.api.nvim_get_hl(0, { name = group })
            hl.bg = nil
            hl.ctermbg = nil
            vim.api.nvim_set_hl(0, group, hl)
          end

          local C = require('github-theme.lib.color')
          local s = require('github-theme.spec').load('github_dark_default')
          local bg = C(s.bg1):blend(C(s.palette.blue.base), 0.2):to_css()
          vim.api.nvim_set_hl(0, 'CursorLine', { bg = bg })
        end,
      })

      vim.cmd.colorscheme('github_dark_default')
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
          theme = 'auto'
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
