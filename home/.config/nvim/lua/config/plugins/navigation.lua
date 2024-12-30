return {
  {
    'mhinz/vim-grepper',
    config = function()
      vim.g.grepper = {
        tools = { 'rg', 'git', 'grep' },
        highlight = 1,
        rg = {
          -- TODO: Remove --threads=3 once running on macos sequoia isn't so slow.. See https://github.com/BurntSushi/ripgrep/issues/2925
          grepprg = 'rg -H --no-heading --vimgrep --threads=3',
        },
      }

      vim.keymap.set('n', '<leader>/', ':Grepper -tool rg<CR>', { noremap = true, silent = true })
      vim.keymap.set('n', 'gs', '<plug>(GrepperOperator)', { remap = true })
      vim.keymap.set('x', 'gs', '<plug>(GrepperOperator)', { remap = true })
    end,
  },
  {
    'MagicDuck/grug-far.nvim',
    config = function()
      require('grug-far').setup();
      vim.keymap.set('n', 'gS', '<cmd>GrugFar<CR>', { noremap = true, silent = true })
    end
  },
  {
    'ibhagwan/fzf-lua',
    config = function()
      local fzf = require('fzf-lua')
      local actions = require('fzf-lua.actions')
      fzf.setup({
        'max-perf',
        winopts = {
          backdrop = false,
          border = 'single',
          preview = {
            hidden = 'hidden',
          },
        },
        winopts_fn = function()
          local split = 'belowright new'
          local height = math.floor(vim.o.lines * 0.35)
          return { split = split .. ' | resize ' .. tostring(height) }
        end,
        files = {
          no_header = true,
          no_header_i = true,
          multiprocess = true,
          git_icons = false,
          file_icons = false,
          color_icons = false,
          cwd_prompt = false,
          actions = {
            ['ctrl-g'] = { actions.toggle_ignore },
          },
          fd_opts = [[--type file --color=never --hidden --follow --strip-cwd-prefix --exclude .git]],
        },
        fzf_opts = {
          ['--ansi'] = true,
          ['--layout'] = 'default',
          ['--border'] = 'none',
        },
        fzf_colors = {
          -- Just use the telescope theme that will match other pickers...
          ['fg'] = { 'fg', 'TelescopeNormal' },
          ['bg'] = { 'bg', 'TelescopeNormal' },
          ['hl'] = { 'fg', 'TelescopeMatching' },
          ['fg+'] = { 'fg', 'TelescopeSelection' },
          ['bg+'] = { 'bg', 'TelescopeSelection' },
          ['hl+'] = { 'fg', 'TelescopeMatching' },
          ['info'] = { 'fg', 'TelescopeMultiSelection' },
          ['border'] = { 'fg', 'TelescopeBorder' },
          ['gutter'] = '-1',
          ['query'] = { 'fg', 'TelescopePromptNormal' },
          ['prompt'] = { 'fg', 'TelescopePromptPrefix' },
          ['pointer'] = { 'fg', 'TelescopeSelectionCaret' },
          ['marker'] = { 'fg', 'TelescopeSelectionCaret' },
          ['header'] = { 'fg', 'TelescopeTitle' },
        },
      })
      vim.keymap.set('n', '<leader><leader>', fzf.files, { silent = true })
    end,
  },

  {
    'nvim-telescope/telescope.nvim',
    version = '*',
    config = function()
      local telescope = require('telescope')
      local builtin = require('telescope.builtin')
      local actions = require('telescope.actions')

      -- vim.keymap.set('n', '<leader>;', builtin.buffers)
      -- vim.keymap.set('n', ';', builtin.buffers)
      -- vim.keymap.set('n', '<leader>t', builtin.find_files)
      -- vim.keymap.set('n', '<leader>g', builtin.git_files)
      -- vim.keymap.set('n', '<leader>s', builtin.git_status)
      -- vim.keymap.set('n', '//', builtin.current_buffer_fuzzy_find)

      telescope.setup({
        defaults = {
          mappings = {
            i = {
              ['<esc>'] = actions.close, -- Close when hitting escape in insert mode, rather than going to normal mode
              ['<C-q>'] = actions.smart_send_to_qflist + actions.open_qflist,
            },
            n = {
              ['<C-q>'] = actions.smart_send_to_qflist + actions.open_qflist,
            },
          },
        },
        pickers = {
          buffers = {
            theme = 'ivy',
            previewer = false,
            results_title = false,
            preview_title = false,
            sorting_strategy = 'descending',
            sort_lastused = true,
            sort_mru = true,
            layout_config = {
              height = 0.35,
              prompt_position = 'bottom',
              preview_width = 0.45,
            },
            mappings = {
              i = {
                ['<C-d>'] = actions.delete_buffer,
              },
              n = {
                ['<C-d>'] = actions.delete_buffer,
              },
            },
          },
          find_files = {
            find_command = {
              'fd',
              '--type',
              'file',
              '--color=never',
              '--hidden',
              '--strip-cwd-prefix',
              '--exclude',
              '.git',
            },
            theme = 'ivy',
            results_title = false,
            preview_title = false,
            sorting_strategy = 'descending',
            layout_config = {
              height = 0.35,
              prompt_position = 'bottom',
              preview_width = 0.45,
            },
          },
          git_files = {
            theme = 'ivy',
            results_title = false,
            preview_title = false,
            sorting_strategy = 'descending',
            layout_config = {
              height = 0.35,
              prompt_position = 'bottom',
              preview_width = 0.45,
            },
          },
          current_buffer_fuzzy_find = {
            sorting_strategy = 'ascending',
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
      -- telescope.load_extension('toggleterm_manager')
      -- telescope.load_extension('termfinder')
      -- telescope.load_extension('vim_bookmarks')
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
    "toggleterm-manager.nvim",
    dir = "~/dev/toggleterm-manager.nvim",
    dependencies = {
      "akinsho/toggleterm.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim",
    },
    config = true
  },
  -- {
  --   "ryanmsnyder/toggleterm-manager.nvim",
  --   dependencies = {
  --     "akinsho/toggleterm.nvim",
  --     "nvim-telescope/telescope.nvim",
  --     "nvim-lua/plenary.nvim",
  --   },
  --   config = true
  -- },
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = true
  },
  -- 'tknightz/telescope-termfinder.nvim',
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
    config = true
  },
  {
    "rgroli/other.nvim",
    config = function()
      require("other-nvim").setup({
        mappings = {
          "rust",
          -- elixir & phoenix
          {
            pattern = "lib/(.*)_web/live/(.*)_live/(.*).html.heex",
            target = { { target = "lib/%1_web/live/%2_live/%3.ex" } },
          },
          {
            pattern = "lib/(.*).ex",
            target = { { target = "test/%1_test.exs" } },
          },
          {
            pattern = "lib/(.*)/(.*).ex",
            target = { { target = "test/%1/%2_test.exs" } },
          },
          {
            pattern = "test/(.*)_test.exs",
            target = { { target = "lib/%1.ex" } },
          },
        },
      })
    end,
    keys = {
      {
        "<leader>fa",
        function()
          vim.cmd("Other")
        end,
        desc = "Alternate",
      },
      {
        "<leader>fm",
        function()
          vim.cmd("Oil")
        end,
        desc = "Manager (Oil)",
      },
      {
        "<leader>fA",
        function()
          vim.cmd("OtherVSplit")
        end,
        desc = "Alternate (VSplit)",
      },
    },
  },
  -- {
  --   'mattesgroeger/vim-bookmarks',
  --   config = function()
  --     vim.g.bookmark_save_per_working_dir = true
  --     vim.g.bookmark_auto_save = true
  --     vim.g.bookmark_display_annotation = true
  --     vim.g.bookmark_show_toggle_warning = false
  --
  --     local bookmarks = require('telescope').extensions.vim_bookmarks
  --
  --     local common_settings = {
  --       layout_strategy = 'vertical',
  --     }
  --
  --     local function all()
  --       bookmarks.all(common_settings)
  --     end
  --
  --     local function current_file()
  --       bookmarks.current_file(common_settings)
  --     end
  --
  --     vim.keymap.set('n', 'ma', all)
  --     vim.keymap.set('n', 'mb', current_file)
  --   end,
  -- }
}
