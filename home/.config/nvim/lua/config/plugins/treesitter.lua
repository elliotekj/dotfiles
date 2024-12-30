return {
  {
    'nvim-treesitter/nvim-treesitter',
    config = function()
      require('nvim-treesitter.configs').setup({
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
      })
    end,
    build = function()
      pcall(require('nvim-treesitter.install').update({ with_sync = true }))
    end,
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
  },
}
