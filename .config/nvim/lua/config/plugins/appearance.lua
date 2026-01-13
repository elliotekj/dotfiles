return {
  'datsfilipe/vesper.nvim',
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
          component_separators = { left = '', right = '' },
          section_separators = { left = '', right = '' },
          theme = 'vesper'
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
    "arnamak/stay-centered.nvim",
    config = function()
      require("stay-centered").setup()

      -- Disable in Diffview panels
      local disable_ft = {
        DiffviewFiles = true,
        DiffviewFilePanel = true,
        DiffviewFileHistoryPanel = true,
      }

      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          local ft = vim.bo[args.buf].filetype
          if disable_ft[ft] then
            require("stay-centered").disable()
          end
        end,
      })

      vim.api.nvim_create_autocmd("BufWinLeave", {
        callback = function(args)
          local ft = vim.bo[args.buf].filetype
          if disable_ft[ft] then
            require("stay-centered").enable()
          end
        end,
      })
    end,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = "BufReadPost",
    opts = {},
    keys = {
      { "<localleader>ti", "<cmd>IBLToggle<cr>", desc = "Toggle indent lines" },
    },
  },
}
