return {
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate',
    config = function ()
      local parsers = { 'elixir', 'erlang' }
      local install_dir = vim.fn.stdpath('data') .. '/site'
      local treesitter = require('nvim-treesitter')

      if treesitter.install then
        treesitter.setup {
          install_dir = install_dir,
        }
        treesitter.install(parsers)
      else
        require('nvim-treesitter.configs').setup {
          parser_install_dir = install_dir,
          ensure_installed = parsers,
        }
      end

      vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'elixir', 'erlang' },
        callback = function(args) vim.treesitter.start(args.buf, args.match) end,
      })
    end
  }
}
