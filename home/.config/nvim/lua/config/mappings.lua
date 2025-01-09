-- set leader to space instead of the default backslash
vim.g.mapleader = ' '
vim.g.maplocalleader = ","
vim.keymap.set('n', '<space>', '<nop>')
vim.keymap.set('n', ',', '<nop>')

-- disable arrow keys
vim.keymap.set('', '<up>', '<nop>')
vim.keymap.set('', '<up>', '<nop>')
vim.keymap.set('', '<down>', '<nop>')
vim.keymap.set('', '<left>', '<nop>')
vim.keymap.set('', '<right>', '<nop>')
vim.keymap.set('i', '<up>', '<nop>')
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

-- diagnostic
-- vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
-- vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)
-- vim.keymap.set('n', '[g', vim.diagnostic.goto_prev)
-- vim.keymap.set('n', ']g', vim.diagnostic.goto_next)

-- windows
vim.keymap.set('n', '<leader>ws', ':split<cr>')
vim.keymap.set('n', '<leader>wv', ':vsplit<cr>')
vim.keymap.set('n', '<leader>wl', '<C-w>l')
vim.keymap.set('n', '<leader>wj', '<C-w>j')
vim.keymap.set('n', '<leader>wk', '<C-w>k')
vim.keymap.set('n', '<leader>wh', '<C-w>h')

-- buffers
vim.keymap.set('n', '<leader>bk', ':bd<cr>')
vim.keymap.set('n', '<leader>bn', ':bnext<cr>')
vim.keymap.set('n', '<leader>bp', ':bprevious<cr>')
vim.keymap.set('n', 'gs/', ':HopPattern<cr>')

-- files
vim.keymap.set('n', '<leader>fs', ':w<cr>')

-- git
vim.keymap.set('n', '<leader>gg', ':Neogit<cr>')

-- terminal
vim.keymap.set('n', '<d-j>', function()
  local terms = require('toggleterm.terminal').get_all()
  if #terms > 0 then
    if vim.bo.buftype == 'terminal' then
      terms[#terms]:close()
    else
      terms[#terms]:toggle()
    end
  else
    require('toggleterm.terminal').Terminal:new():open(vim.o.lines / 2, "horizontal")
  end
end)

vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]])
vim.keymap.set('t', 'jk', [[<C-\><C-n>]])
vim.keymap.set('t', '<C-h>', [[<C-\><C-n><C-w>h]])
vim.keymap.set('t', '<C-j>', [[<C-\><C-n><C-w>j]])
vim.keymap.set('t', '<C-k>', [[<C-\><C-n><C-w>k]])
vim.keymap.set('t', '<C-l>', [[<C-\><C-n><C-w>l]])

-- lsp
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('LspKeymapConfig', {}),
  callback = function(args)
    -- enable completion triggered by <c-x><c-o>
    vim.bo[args.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- buffer local mappings.
    local opts = { buffer = args.buf }
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    -- vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    -- vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    -- vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    -- vim.keymap.set('n', 'gy', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    -- vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    -- vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    -- vim.keymap.set({ 'n', 'v' }, '<leader>a', vim.lsp.buf.code_action, opts)
  end,
})
