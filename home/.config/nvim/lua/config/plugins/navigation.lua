return {
  {
    'MagicDuck/grug-far.nvim',
    config = function()
      require('grug-far').setup();
      vim.keymap.set('n', 'gpS', '<cmd>GrugFar<CR>', { noremap = true, silent = true })
    end
  },
  {
    'nvim-telescope/telescope.nvim',
    version = '*',
    config = function()
      local telescope = require('telescope')
      local builtin = require('telescope.builtin')
      local actions = require('telescope.actions')

      -- Project mappings
      vim.keymap.set('n', '<leader><leader>', builtin.find_files)
      vim.keymap.set('n', '<leader>/', builtin.live_grep)
      vim.keymap.set('n', 'gps', builtin.lsp_workspace_symbols)

      -- Buffer mappings
      vim.keymap.set('n', '//', builtin.current_buffer_fuzzy_find)
      vim.keymap.set('n', 'gbs', builtin.lsp_document_symbols)
      vim.keymap.set('n', 'gbt', builtin.treesitter)

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
    "akinsho/toggleterm.nvim",
    version = "*",
    config = true
  },
  {
    'smoka7/hop.nvim',
    version = "*",
    opts = {
      keys = 'asdghklqwertyuiopzxcvbnmfj'
    }
  },
  {
    'stevearc/oil.nvim',
    dependencies = { { "echasnovski/mini.icons", opts = {} } },
    config = function()
      require("oil").setup()
      vim.keymap.set("n", "<leader>fe", ":Oil<CR>", { noremap = true, silent = true })
    end,
  },
  {
    'tpope/vim-projectionist',
    config = function()
      vim.keymap.set("n", "<leader>fa", ":A<CR>", { noremap = true, silent = true })
    end,
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
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
  }
}
