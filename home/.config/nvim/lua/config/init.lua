-- Most of this is based on https://github.com/ddeville/scripts/tree/master/config/common/.config/nvim/lua/config

require('config.mappings')

-- Install plugins after mappings to make sure that plugins don't end up using old wrong ones...
require('config.lazy')

require('config.autocmd')
require('config.settings')
