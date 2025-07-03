return
{
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",  -- required
      "sindrets/diffview.nvim", -- optional - Diff integration

      -- Only one of these is needed.
      "nvim-telescope/telescope.nvim", -- optional
      -- "ibhagwan/fzf-lua",              -- optional
      -- "echasnovski/mini.pick",         -- optional
    },
    config = true
  },
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        local function map(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end

        map('n', ']h', gs.next_hunk, 'Next Hunk')
        map('n', '[h', gs.prev_hunk, 'Prev Hunk')
      end,
    }
  },
  {
    "elliotekj/claude-commit.nvim",
    ft = "gitcommit",
    config = function()
      require("claude-commit").setup({
        auto_suggest = true, -- default
        timeout = 10000,     -- default
      })
    end,
  },
  {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("diffview").setup()

      vim.keymap.set("n", "<leader>gd", function()
        local function open_diff()
          vim.cmd("DiffviewOpen origin/master")
        end

        -- Run `git remote show origin` and parse status
        vim.system({ "git", "remote", "show", "origin" }, { text = true }, function(result)
          local output = result.stdout or ""

          local needs_fetch = output:match("local out of date") or
              output:match("behind") or
              output:match("diverged")

          if needs_fetch then
            vim.schedule(function()
              vim.ui.select({ "Yes", "No" }, {
                prompt = "origin/master is outdated. Fetch before diff?",
              }, function(choice)
                if choice == "Yes" then
                  vim.system({ "git", "fetch", "origin" }, {}, function()
                    vim.schedule(open_diff)
                  end)
                else
                  open_diff()
                end
              end)
            end)
          else
            vim.schedule(open_diff)
          end
        end)
      end, { desc = "Diff HEAD vs origin/master (smart fetch)" })
    end
  }
}
