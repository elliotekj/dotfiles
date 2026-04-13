local servers = {
  elixirls = {
    filetypes = { 'elixir', 'eelixir', 'heex' },
    root_markers = { 'mix.exs', '.git' },
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

-- Set default capabilities for all servers (includes cmp support)
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())
vim.lsp.config('*', { capabilities = capabilities })

-- Configure each server
local server_names = {}
for name, config in pairs(servers) do
  vim.lsp.config(name, config)
  server_names[#server_names + 1] = name
end

-- Enable all servers
vim.lsp.enable(server_names)

return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      {
        'williamboman/mason-lspconfig.nvim',
        version = '*',
        priority = 1000,
        config = function()
          local skip_auto_install = { pyright = true }
          local install_names = {}
          for name, _ in pairs(servers) do
            if not skip_auto_install[name] then
              install_names[#install_names + 1] = name
            end
          end
          require('mason-lspconfig').setup({
            ensure_installed = install_names,
            automatic_installation = true,
          })
        end,
      },
    },
  },
  {
    'j-hui/fidget.nvim',
    config = function()
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
