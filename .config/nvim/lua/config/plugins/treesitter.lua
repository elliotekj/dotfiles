return {
  {
    'nvim-treesitter/nvim-treesitter',
    config = function()
      local parser_install_dir = vim.fn.stdpath('data') .. '/treesitter-parsers'
      vim.opt.runtimepath:append(parser_install_dir)

      require('nvim-treesitter.configs').setup({
        parser_install_dir = parser_install_dir,
        ensure_installed = {
          'awk',
          'bash',
          'c',
          'cmake',
          'comment',
          'cpp',
          'css',
          'diff',
          'dockerfile',
          'eex',
          'elixir',
          'erlang',
          'git_config',
          'git_rebase',
          'gitattributes',
          'gitignore',
          'go',
          'gomod',
          'gosum',
          'gowork',
          'heex',
          'html',
          'javascript',
          'json',
          'jq',
          'lua',
          'luadoc',
          'make',
          'markdown',
          'ninja',
          'objc',
          'proto',
          'python',
          'regex',
          'rust',
          'sql',
          'terraform',
          'toml',
          'typescript',
          'vim',
          'vimdoc',
          'yaml',
        },
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "e",
            node_incremental = "e",
            node_decremental = "E",
          },
        },
      })
    end,
    build = ':TSUpdate',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
  },
}
