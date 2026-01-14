local servers = {
  lexical = {
    cmd = { vim.fn.stdpath('data') .. '/mason/bin/lexical' },
    filetypes = { 'elixir', 'eelixir', 'heex' },
    root_dir = function(fname)
      return require('lspconfig.util').root_pattern('mix.exs', '.git')(fname)
    end,
  },

  gopls = {
    settings = {
      gopls = {
        analyses = {
          unusedparams = true,
        },
        staticcheck = true,
      },
    },
  },

  ts_ls = {},

  pyright = {
    settings = {
      python = {
        analysis = {
          autoSearchPaths = true,
          diagnosticMode = 'workspace',
          typeCheckingMode = 'basic',
          useLibraryCodeForTypes = true,
          diagnosticSeverityOverrides = {
            reportMissingImports = false,
            reportMissingTypeStubs = false,
            reportPrivateImportUsage = false,
            reportGeneralTypeIssues = 'information',
            reportUnusedClass = 'warning',
            reportUnusedFunction = 'warning',
            reportDuplicateImport = 'warning',
            reportUntypedFunctionDecorator = 'warning',
            reportUntypedClassDecorator = 'warning',
            reportUntypedBaseClass = 'warning',
            reportUntypedNamedTuple = 'warning',
            reportTypeCommentUsage = 'warning',
            reportIncompatibleMethodOverride = 'warning',
            reportIncompatibleVariableOverride = 'warning',
            reportInconsistentConstructor = 'warning',
            reportUninitializedInstanceVariable = 'warning',
            reportUnnecessaryIsInstance = 'warning',
            reportUnnecessaryCast = 'warning',
            reportUnnecessaryComparison = 'warning',
            reportUnnecessaryContains = 'warning',
            reportUnnecessaryTypeIgnoreComment = 'warning',
          },
        },
        venvPath = os.getenv('PYENV_ROOT') and os.getenv('PYENV_ROOT') .. '/versions' or nil,
      },
    },
  },

  rust_analyzer = {
    settings = {
      ['rust-analyzer'] = {
        checkOnSave = {
          enable = true,
          -- Build out of tree so that we don't cause cargo lock contention
          extraArgs = { '--target-dir', '/tmp/rust-analyzer-check' },
        },
        cargo = {
          autoreload = true,
        },
        procMacro = {
          enable = true,
        },
      },
    },
    capabilities = {
      textDocument = {
        completion = {
          completionItem = {
            -- We need snippets for nvim-cmp to fully support rust-analyzer magic
            snippetSupport = true,
            resolveSupport = {
              properties = {
                'documentation',
                'detail',
                'additionalTextEdits',
              },
            },
          },
        },
      },
    },
  },
}

local pre_installed_servers = {}

return {
  {
    'neovim/nvim-lspconfig',
    config = function()
      for name, config in pairs(servers) do
        -- First get the default capabilities of the neovim client
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        -- Second add the cmp-specific capabilities
        capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())
        -- Third add any override from the current server config
        config.capabilities = vim.tbl_deep_extend('force', capabilities, config.capabilities or {})

        require('lspconfig')[name].setup(config)
      end
    end,
    dependencies = {
      {
        'williamboman/mason-lspconfig.nvim',
        version = '*',
        -- It is important for mason and mason-lspconfig's setup to have run before lspconfig's
        priority = 1000,
        config = function()
          local skip_auto_install = { pyright = true }
          local server_names = {}
          for name, _ in pairs(servers) do
            if pre_installed_servers[name] == nil and not skip_auto_install[name] then
              server_names[#server_names + 1] = name
            end
          end
          require('mason-lspconfig').setup({
            ensure_installed = server_names,
            automatic_installation = true,
          })
        end,
      },
    },
  },
  {
    'j-hui/fidget.nvim',
    config = function()
      -- LSP Status
      require('fidget').setup({
        progress = {
          display = {
            progress_icon = { pattern = 'bouncing_bar' },
            done_ttl = 1,
          },
        },
      })
    end,
  },
  {
    'kosayoda/nvim-lightbulb',
    config = function()
      -- Display an indicator in the sign column when a code action is available
      vim.fn.sign_define('LightBulbSign', { text = '▶', texthl = 'LspDiagnosticsDefaultInformation' })
      require('nvim-lightbulb').setup({
        autocmd = { enabled = true },
        sign = {
          enabled = true,
          text = '▶',
          hl = 'LightBulbSign',
        },
      })
    end,
  },
}
