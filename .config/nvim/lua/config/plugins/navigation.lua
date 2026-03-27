local function get_visual_selection()
  vim.cmd('noau normal! "vy"')
  local text = vim.fn.getreg('v')
  vim.fn.setreg('v', {})
  return string.gsub(text, '\n', '')
end

return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      delay = 300,
      icons = {
        mappings = false,
        keys = {},
      },
      win = {
        border = "single",
        padding = { 1, 2 },
      },
      spec = {
        { "<leader>b", group = "buffer" },
        { "<leader>f", group = "file" },
        { "<leader>g", group = "git" },
        { "<leader>t", group = "test" },
        { "<leader>w", group = "window" },
        { "<leader>x", group = "elixir" },
        { "g", group = "goto" },
        { "<localleader>t", group = "toggle" },
      },
    },
  },
  {
    'MagicDuck/grug-far.nvim',
    cmd = "GrugFar",
    keys = {
      { 'gpr', '<cmd>GrugFar<CR>', desc = "Find and replace" },
    },
    opts = {},
  },
  {
    'dmtrKovalenko/fff.nvim',
    build = function()
      require('fff.download').download_or_build_binary()
    end,
    lazy = false,
    opts = {},
    keys = {
      { '<leader>ff', function() require('fff').find_files() end, desc = 'Find files' },
      { '<leader>/', function() require('fff').live_grep() end, desc = 'Live grep' },
      { '<leader>/', function()
        local text = get_visual_selection()
        require('fff').live_grep({ query = text })
      end, mode = 'v', desc = 'Grep selection' },
      { '<leader>*', function() require('fff').live_grep({ query = vim.fn.expand('<cword>') }) end, desc = 'Grep current word' },
    },
  },
  {
    'nvim-telescope/telescope.nvim',
    version = '*',
    config = function()
      local telescope = require('telescope')
      local builtin = require('telescope.builtin')
      local actions = require('telescope.actions')

      vim.keymap.set('n', 'gps', builtin.lsp_workspace_symbols, { desc = "Workspace symbols" })
      vim.keymap.set('n', '//', builtin.current_buffer_fuzzy_find, { desc = "Buffer search" })
      vim.keymap.set('n', 'gbs', builtin.lsp_document_symbols, { desc = "Buffer symbols" })
      vim.keymap.set('n', 'gbt', builtin.treesitter, { desc = "Buffer treesitter" })
      vim.keymap.set('n', "<leader>'", builtin.resume, { desc = "Resume picker" })

      telescope.setup({
        defaults = {
          mappings = {
            i = {
              ['<esc>'] = actions.close,
              ['<C-q>'] = actions.smart_send_to_qflist + actions.open_qflist,
            },
            n = {
              ['<C-q>'] = actions.smart_send_to_qflist + actions.open_qflist,
            },
          },
        },
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = 'smart_case',
          },
        },
      })

      telescope.load_extension('fzf')
    end,
    dependencies = {
      'nvim-lua/popup.nvim',
      'nvim-lua/plenary.nvim',
    },
  },
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build =
    'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build',
    cond = function()
      return vim.fn.executable('cmake') == 1
    end,
  },
  {
    'smoka7/hop.nvim',
    version = "*",
    keys = {
      { 'gs/', '<cmd>HopPattern<cr>', desc = "Hop to pattern" },
      { 'gw', '<cmd>HopWord<cr>', mode = { 'n', 'v' }, desc = "Hop to word" },
    },
    opts = {
      keys = 'asdghklqwertyuiopzxcvbnmfj'
    }
  },
  {
    'stevearc/oil.nvim',
    lazy = false,
    keys = {
      { "<leader>fe", "<cmd>Oil<CR>", desc = "Open file explorer" },
    },
    dependencies = { { "echasnovski/mini.icons", opts = {} } },
    opts = {},
  },
  {
    'tpope/vim-projectionist',
    keys = {
      { "gfa", "<cmd>A<CR>", desc = "Alternate file" },
    },
  },
  {
    "folke/trouble.nvim",
    opts = {},
    cmd = "Trouble",
    keys = {
      {
        "gpd",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "gbd",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
    },
  },
  {
    "folke/todo-comments.nvim",
    event = "BufReadPost",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
  },
  {
    "famiu/bufdelete.nvim",
    keys = {
      { "<leader>bk", "<cmd>Bdelete<cr>",  desc = "Delete buffer" },
      { "<leader>bK", "<cmd>Bdelete!<cr>", desc = "Force delete buffer" },
    }
  },
  {
    "hedyhli/outline.nvim",
    cmd = "Outline",
    keys = {
      { "<localleader>to", "<cmd>Outline<CR>", desc = "Toggle Outline" },
    },
    opts = {},
  },
}
