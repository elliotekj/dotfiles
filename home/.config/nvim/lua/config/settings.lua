-- dark background is better
vim.opt.background = 'dark'
vim.g.everforest_background = 'hard'
vim.g.everforest_enable_italic = true
vim.cmd.colorscheme('everforest')
-- vim.cmd.colorscheme("gruber-darker")

-- make background transparent
vim.cmd [[
  highlight Normal guibg=NONE ctermbg=NONE
  highlight NonText guibg=NONE ctermbg=NONE
  highlight NormalNC guibg=NONE ctermbg=NONE
  highlight NormalFloat guibg=NONE ctermbg=NONE
  highlight TelescopeNormal guibg=NONE ctermbg=NONE
  highlight TelescopeBorder guibg=NONE ctermbg=NONE
  highlight SignColumn guibg=NONE ctermbg=NONE
  highlight VertSplit guibg=NONE ctermbg=NONE
  highlight EndOfBuffer guibg=NONE ctermbg=NONE
  highlight Folded guibg=NONE ctermbg=NONE
  highlight FloatBorder guibg=NONE ctermbg=NONE
  highlight Pmenu guibg=NONE ctermbg=NONE
  highlight LineNr guibg=NONE ctermbg=NONE
  highlight CursorLineNr guibg=NONE ctermbg=NONE
  highlight WinSeparator guibg=NONE ctermbg=NONE
]]

-- allow switching between buffers without saving first
vim.opt.hidden = true

-- if no known file type keep the same indent as the current line
vim.opt.autoindent = true

-- use 2 spaces instead of tabs
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

-- shorten the delay to transition to normal mode after pressing escape
vim.opt.timeoutlen = 1000
vim.opt.ttimeoutlen = 0

-- set mouse support so that we can select text and tabs
vim.opt.mouse = 'a'

-- lower how long it takes for cursor hold to kick off (for code actions for example)
vim.opt.updatetime = 300

-- backspace through anything in insert mode
vim.opt.backspace = [[indent,eol,start]]

-- highlight search results and start searching immediately
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- no swap/backup and store undo files under XDG state dir
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true

-- always show at least one line above/below the cursor (and 5 on each side if not wrapping)
vim.opt.scrolloff = 1
vim.opt.sidescrolloff = 5

-- display the cursor position in the status line
vim.opt.ruler = true

-- display the line number on the left
vim.opt.number = false

-- show the diagnostic ui where the number goes
vim.opt.signcolumn = 'number'

-- hide concealed text
vim.opt.conceallevel = 2

-- display a column at 120 char
-- vim.opt.colorcolumn = '120'

-- highlight the current line
vim.opt.cursorline = true

-- views can only be fully collapsed with the global statusline
vim.opt.laststatus = 3

-- autoload file changes
vim.opt.autoread = true

-- automatically reload buffer when file changes
local auto_reload_ag = vim.api.nvim_create_augroup('AutoReload', { clear = true })
vim.api.nvim_create_autocmd({ 'FocusGained', 'BufEnter', 'CursorHold', 'CursorHoldI' }, {
  group = auto_reload_ag,
  command = 'if mode() != "c" | checktime | endif',
})
vim.api.nvim_create_autocmd('FileChangedShellPost', {
  group = auto_reload_ag,
  command = 'echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None',
})

-- open new splits on right and bottom
vim.opt.splitbelow = true
vim.opt.splitright = true

-- don't add an extra space when joining lines
vim.g.nojoinspaces = true

-- netrw
vim.gnetrw_localrmdir = 'rm -r'
vim.gnetrw_liststyle = 4
vim.gnetrw_winsize = 85
vim.gnetrw_browse_split = 0

-- don't give |ins-completion-menu| messages.
vim.opt.shortmess:append({ c = true })

-- trailing whitespace is bad
vim.api.nvim_set_hl(0, 'WhiteSpaceEOL', { ctermbg = 1 })
local trailing_ag = vim.api.nvim_create_augroup('TrailingWhitespace', { clear = true })
vim.api.nvim_create_autocmd('InsertEnter', {
  group = trailing_ag,
  command = [[match WhiteSpaceEOL /\s\+\%#\@<!$/]],
})
vim.api.nvim_create_autocmd('InsertLeave', {
  group = trailing_ag,
  command = [[match WhiteSpaceEOL /\s\+$/]],
})

-- highlight on yank
local highlight_ag = vim.api.nvim_create_augroup('HighlightOnYank', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  group = highlight_ag,
  callback = function()
    vim.highlight.on_yank({ timeout = 350 })
  end,
})

-- disable lsp logs
vim.lsp.set_log_level('off')

-- disable lsp semantic tokens since we use treesitter for syntax highlighting anyway...
-- (see https://www.reddit.com/r/neovim/comments/109vgtl/how_to_disable_highlight_from_lsp)
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('LspDisableSemanticTokensProvider', {}),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    client.server_capabilities.semanticTokensProvider = nil
  end,
})

-- setup diagnostics
vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
  signs = true,
  underline = true,
  virtual_text = {
    spacing = 4,
    severity = { min = vim.diagnostic.severity.WARN }, -- Basically show all messages
  },
  update_in_insert = false,
})

vim.diagnostic.config({
  severity_sort = true,
  signs = true,
  virtual_text = true,
  float = { scope = 'line' },
})

-- -- setup gutter signs for diagnostics
-- vim.fn.sign_define('DiagnosticSignError', { text = 'E', texthl = 'DiagnosticSignError', priority = 40 })
-- vim.fn.sign_define('DiagnosticSignWarn', { text = 'W', texthl = 'DiagnosticSignWarn', priority = 30 })
-- vim.fn.sign_define('DiagnosticSignInfo', { text = 'I', texthl = 'DiagnosticDefaultInfo', priority = 20 })
-- vim.fn.sign_define('DiagnosticSignHint', { text = 'H', texthl = 'DiagnosticDefaultHint', priority = 10 })
--
-- -- diagnostic highlights
-- vim.api.nvim_set_hl(0, 'DiagnosticError', { fg = 'Red', ctermfg = 'Red' })
-- vim.api.nvim_set_hl(0, 'DiagnosticUnderlineError', { fg = 'Red', ctermfg = 'Red', cterm = { underline = true } })
-- vim.api.nvim_set_hl(0, 'DiagnosticVirtualTextError', { fg = 'Red', ctermfg = 'Red' })
-- vim.api.nvim_set_hl(0, 'DiagnosticFloatingError', { fg = 'Red', ctermfg = 'Red' })
-- vim.api.nvim_set_hl(0, 'DiagnosticSignError', { fg = 'Red', ctermfg = 'Red' })
--
-- vim.api.nvim_set_hl(0, 'DiagnosticWarn', { fg = 'Yellow', ctermfg = 'Yellow' })
-- vim.api.nvim_set_hl(0, 'DiagnosticUnderlineWarn', { fg = 'Yellow', ctermfg = 'Yellow', cterm = { underline = true } })
-- vim.api.nvim_set_hl(0, 'DiagnosticVirtualTextWarn', { fg = 'Yellow', ctermfg = 'Yellow' })
-- vim.api.nvim_set_hl(0, 'DiagnosticFloatingWarn', { fg = 'Yellow', ctermfg = 'Yellow' })
-- vim.api.nvim_set_hl(0, 'DiagnosticSignWarn', { fg = 'Yellow', ctermfg = 'Yellow' })
--
-- vim.api.nvim_set_hl(0, 'DiagnosticInfo', { fg = 'White', ctermfg = 'White' })
-- vim.api.nvim_set_hl(0, 'DiagnosticUnderlineInfo', { fg = 'White', ctermfg = 'White', cterm = { underline = true } })
-- vim.api.nvim_set_hl(0, 'DiagnosticVirtualTextInfo', { fg = 'White', ctermfg = 'White' })
-- vim.api.nvim_set_hl(0, 'DiagnosticFloatingInfo', { fg = 'White', ctermfg = 'White' })
-- vim.api.nvim_set_hl(0, 'DiagnosticSignInfo', { fg = 'White', ctermfg = 'White' })
--
-- vim.api.nvim_set_hl(0, 'DiagnosticHint', { fg = 'Gray', ctermfg = 'Gray' })
-- vim.api.nvim_set_hl(0, 'DiagnosticUnderlineHint', { fg = 'Gray', ctermfg = 'Gray', cterm = { underline = true } })
-- vim.api.nvim_set_hl(0, 'DiagnosticVirtualTextHint', { fg = 'Gray', ctermfg = 'Gray' })
-- vim.api.nvim_set_hl(0, 'DiagnosticFloatingHint', { fg = 'Gray', ctermfg = 'Gray' })
-- vim.api.nvim_set_hl(0, 'DiagnosticSignHint', { fg = 'Gray', ctermfg = 'Gray' })
