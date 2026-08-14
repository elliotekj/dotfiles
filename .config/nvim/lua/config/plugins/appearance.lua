local function buffer_offset()
  local offset = vim.fn.line2byte(vim.fn.line('.')) + vim.fn.col('.') - 1
  return math.max(offset, 0)
end

return {
  {
    'sainnhe/gruvbox-material',
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.gruvbox_material_background = 'soft'
      vim.g.gruvbox_material_foreground = 'material'

      local theme_by_background = {
        dark = 'gruvbox-material',
        light = 'gruvbox-material',
      }

      local current_background

      local function macos_background()
        if vim.uv.os_uname().sysname ~= 'Darwin' then
          return nil
        end

        local result = vim.system({ 'defaults', 'read', '-g', 'AppleInterfaceStyle' }, { text = true }):wait()
        if result.code == 0 and result.stdout:match('Dark') then
          return 'dark'
        end

        return 'light'
      end

      local function detected_background()
        if #vim.api.nvim_list_uis() > 0 then
          return vim.o.background
        end

        return macos_background() or vim.o.background
      end

      local function background_from_terminal_response(sequence)
        if not sequence then
          return nil
        end

        local red, green, blue = sequence:match('\027%]11;rgb:(%x+)/(%x+)/(%x+)')
        if not red then
          return nil
        end

        local function channel(hex)
          return tonumber(hex, 16) / (16 ^ #hex - 1)
        end

        local luminance = 0.2126 * channel(red) + 0.7152 * channel(green) + 0.0722 * channel(blue)
        if luminance < 0.5 then
          return 'dark'
        end

        return 'light'
      end

      local function apply_theme(background)
        if background == current_background then
          return
        end

        current_background = background
        vim.o.background = background
        vim.cmd.colorscheme(theme_by_background[background])
      end

      local function query_terminal_background()
        if #vim.api.nvim_list_uis() == 0 then
          return
        end

        io.stdout:write('\027]11;?\027\\')
        io.stdout:flush()
      end

      apply_theme(detected_background())

      vim.api.nvim_create_autocmd('UIEnter', {
        callback = function()
          vim.schedule(function()
            apply_theme(vim.o.background)
            query_terminal_background()
          end)
        end,
      })

      vim.api.nvim_create_autocmd('TermResponse', {
        callback = function(args)
          local sequence = args.data and args.data.sequence or vim.v.termresponse
          local background = background_from_terminal_response(sequence)
          if background then
            apply_theme(background)
          end
        end,
      })

      vim.api.nvim_create_autocmd('OptionSet', {
        pattern = 'background',
        callback = function(args)
          if args.match ~= 'background' then
            return
          end

          vim.schedule(function()
            apply_theme(vim.o.background)
          end)
        end,
      })

      vim.api.nvim_create_autocmd('FocusGained', {
        callback = function()
          apply_theme(detected_background())
          query_terminal_background()
        end,
      })
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
          theme = 'gruvbox-material'
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
