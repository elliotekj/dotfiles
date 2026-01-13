-- set leader to space instead of the default backslash
vim.g.mapleader = ' '
vim.g.maplocalleader = ","
vim.keymap.set('n', '<space>', '<nop>')
vim.keymap.set('n', ',', '<nop>')

-- disable arrow keys
vim.keymap.set('', '<up>', '<nop>')
vim.keymap.set('', '<down>', '<nop>')
vim.keymap.set('', '<left>', '<nop>')
vim.keymap.set('', '<right>', '<nop>')
vim.keymap.set('i', '<up>', '<nop>')
vim.keymap.set('i', '<down>', '<nop>')
vim.keymap.set('i', '<left>', '<nop>')
vim.keymap.set('i', '<right>', '<nop>')

-- jk to escape
vim.keymap.set('i', 'jk', '<esc>')

-- move lines up and down when in visual mode
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")

-- map screen redraw to also turn off search highlighting
vim.keymap.set('n', '<C-l>', ':nohl<CR><C-l>')

-- make Y behave like D and C
vim.keymap.set('n', 'Y', 'y$')

-- windows
vim.keymap.set('n', '<leader>ws', ':split<cr>', { desc = 'Split horizontal' })
vim.keymap.set('n', '<leader>wv', ':vsplit<cr>', { desc = 'Split vertical' })
vim.keymap.set('n', '<leader>wl', '<C-w>l', { desc = 'Go right' })
vim.keymap.set('n', '<leader>wj', '<C-w>j', { desc = 'Go down' })
vim.keymap.set('n', '<leader>wk', '<C-w>k', { desc = 'Go up' })
vim.keymap.set('n', '<leader>wh', '<C-w>h', { desc = 'Go left' })
vim.keymap.set('n', '<leader>wx', '<C-w>c', { desc = 'Close' })

-- buffers
vim.keymap.set('n', '<leader>bn', ':bnext<cr>', { desc = 'Next' })
vim.keymap.set('n', '<leader>bp', ':bprevious<cr>', { desc = 'Previous' })

-- files
vim.keymap.set('n', '<leader>fs', ':w<cr>')

-- git
vim.keymap.set('n', '<leader>gg', ':Neogit<cr>')

-- lsp
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('LspKeymapConfig', {}),
  callback = function(args)
    -- enable completion triggered by <c-x><c-o>
    vim.bo[args.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    local opts = { buffer = args.buf }
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
  end,
})
