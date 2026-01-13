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
        { "<leader>h", group = "harpoon" },
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
    'nvim-telescope/telescope.nvim',
    version = '*',
    config = function()
      local telescope = require('telescope')
      local builtin = require('telescope.builtin')
      local actions = require('telescope.actions')

      -- Project mappings
      vim.keymap.set('n', '<leader><leader>', builtin.find_files, { desc = "Find files" })
      vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = "Find files" })
      vim.keymap.set('n', '<leader>/', builtin.live_grep, { desc = "Live grep" })
      vim.keymap.set('v', '<leader>/', function()
        local selected_text = get_visual_selection()
        builtin.live_grep({ default_text = selected_text })
      end, { desc = "Grep selection" })
      vim.keymap.set('n', 'gps', builtin.lsp_workspace_symbols, { desc = "Workspace symbols" })

      -- Buffer mappings
      vim.keymap.set('n', '//', builtin.current_buffer_fuzzy_find, { desc = "Buffer search" })
      vim.keymap.set('n', 'gbs', builtin.lsp_document_symbols, { desc = "Buffer symbols" })
      vim.keymap.set('n', 'gbt', builtin.treesitter, { desc = "Buffer treesitter" })

      -- Other
      vim.keymap.set('n', '<leader>r', builtin.resume, { desc = "Resume picker" })

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
        pickers = {
          find_files = {
            find_command = { "fd", "--type", "file", "--hidden", "--follow", "--strip-cwd-prefix", "--exclude", ".git" },
          },
          live_grep = {
            additional_args = function()
              return { "--hidden", "--glob", "!.git/*" }
            end,
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
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>hh", function() require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) end, desc = "Harpoon menu" },
      { "<leader>ha", function() require("harpoon"):list():add() end, desc = "Harpoon add" },
      { "<leader>hd", function() require("harpoon"):list():remove() end, desc = "Harpoon remove" },
    },
    config = function()
      require("harpoon"):setup()
    end
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
