"---------------------------------------
" BASICS
"---------------------------------------

set nocompatible
filetype plugin indent on
syntax on

runtime macros/matchit.vim

" Basics
set backspace=indent,eol,start
set encoding=utf-8
set hidden
set hlsearch incsearch ignorecase smartcase
set nojoinspaces

" UI
set foldlevelstart=50
set foldmethod=syntax
set laststatus=2
set list listchars=tab:»·,trail:·,nbsp:·|
set scrolloff=999 sidescroll=1 sidescrolloff=5
set showtabline=2
set splitbelow splitright
set statusline=%<%f\ (%{&ft})\ %-4(%m%)%=%-19(%3l,%02c%03V%)

" Perf
set lazyredraw
set timeoutlen=300
set ttimeoutlen=0
set ttyfast
set updatetime=200

" Tabs & intendation
set expandtab
set shiftround shiftwidth=4 softtabstop=4
set smartindent smarttab

" Backups & undos
set nobackup noswapfile
set undofile undodir=$HOME/.vim/undos
set undolevels=1000 undoreload=1000 history=50

" Wildmenu
set wildmenu wildmode=longest:full,full
set wildignore=.hg,.svn,*~,*.png,*.jpg,*.gif,*.settings,Thumbs.db,*.min.js,*.swp,publish/*,intermediate/*,*.o,*.hi,Zend,vendor

" Format options
set formatoptions=tc " Wrap text and comments using textwidth
set formatoptions+=r " Continue comments when pressing ENTER in insert mode
set formatoptions+=q " Enable formatting of comments with gq
set formatoptions+=n " Detect lists for formatting
set formatoptions+=b " Auto-wrap in insert mode, and do not wrap old long lines

"---------------------------------------
" PLUGINS
"---------------------------------------

" Auto-install Vim Plug
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged\')
" UI
Plug 'jonathanfilip/vim-lucius'
Plug 'machakann/vim-highlightedyank'
Plug 'tpope/vim-vinegar'
" Unit testing
Plug 'janko-m/vim-test', { 'on': ['TestFile', 'TestLast', 'TestNearest', 'TestSuite', 'TestVisit'] }
Plug 'tpope/vim-dispatch'
" Find & replace
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'jremmen/vim-ripgrep'
" Editor features
Plug 'SirVer/ultisnips'
" Plug 'dense-analysis/ale'
Plug 'derekprior/vim-trimmer'
Plug 'duggiefresh/vim-easydir'
Plug 'easymotion/vim-easymotion'
Plug 'ludovicchabant/vim-gutentags'
Plug 'sheerun/vim-polyglot'
Plug 'soywod/unfog.vim'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'vimwiki/vimwiki'
Plug 'wakatime/vim-wakatime'
call plug#end()

if executable('rg')
  set grepprg="rg --color never --no-heading"
endif

"---------------------------------------
" MAPPINGS
"---------------------------------------

let g:mapleader = ' '
let g:maplocalleader = ','

inoremap jk <esc>
noremap j gj
noremap k gk

noremap H ^
noremap L $
vnoremap L g_

" Quitting & writing buffers & tabs
nmap <leader>q :bp <bar> bd #<cr>
nnoremap <C-q> :tabc<cr>
nnoremap <leader>k :w<cr>

" Buffer navigation
nmap <silent> <C-k> :wincmd k<CR>
nmap <silent> <C-j> :wincmd j<CR>
nmap <silent> <C-h> :wincmd h<CR>
nmap <silent> <C-l> :wincmd l<CR>

nnoremap <leader>0 <c-w>=
nnoremap <leader>= <c-w>999+
nnoremap <leader>- <c-w>999-

" Copy & paste
if executable('xclip')
    " https://vim.fandom.com/wiki/In_line_copy_and_paste_to_system_clipboard
    vmap <silent> cp y: call system("xclip -i -selection clipboard", getreg("\""))<CR>
    nmap <silent> cv :call setreg("\"",system("xclip -o -selection clipboard"))<CR>p
else
    vnoremap cp "*y
    vnoremap cv "*p
    nnoremap cv "*p
end

set pastetoggle=<F2>

nnoremap <localleader><space> :nohls<cr>
map  <localleader><localleader> <Plug>(easymotion-bd-f)
nmap <localleader><localleader> <Plug>(easymotion-overwin-f)

" Pair expansion on the cheap
inoremap (<CR>  (<CR>)<Esc>O
inoremap (;     (<CR>);<Esc>O
inoremap (,     (<CR>),<Esc>O
inoremap {<CR>  {<CR>}<Esc>O
inoremap {;     {<CR>};<Esc>O
inoremap {,     {<CR>},<Esc>O
inoremap [<CR>  [<CR>]<Esc>O
inoremap [;     [<CR>];<Esc>O
inoremap [,     [<CR>],<Esc>O
inoremap -><CR> -><CR>end)<Esc>O
inoremap do<CR> do<CR>end<Esc>O

imap <C-l> <space>-><space>
imap <C-k> <space>-><cr>end)<Esc>O

let test#strategy = 'dispatch'
map <leader>sr :TestSuite<CR>
map <leader>ss :TestNearest<CR>
map <leader>sf :TestFile<CR>
map <leader>sl :TestLast<CR>

nmap <leader>u :Unfog<cr>
nmap <leader>U :tabnew Unfog<cr>

"---------------------------------------
" COLOURS
"---------------------------------------

let g:lucius_no_term_bg = 1
colorscheme lucius
LuciusDark

" https://github.com/powerline/fonts/blob/master/Inconsolata/Inconsolata%20for%20Powerline.otf
set guifont=InconsolataForPowerline:h14

"---------------------------------------
" AUTOGROUPS
"---------------------------------------

augroup v_center_cursor
  au!

  au BufEnter,WinEnter,VimResized *,*.*
        \ let &scrolloff=winheight(win_getid())/2
augroup END

" augroup global
"     au!

"     " Only show cursor line in the current window and only when in a non-insert mode
"     au WinLeave,InsertEnter * set nocursorline
"     au WinEnter,InsertLeave * set cursorline
" augroup END

"---------------------------------------
" PLUGIN: ALE
"---------------------------------------

" let g:ale_sign_column_always = 1
" let g:ale_emit_conflict_warnings = 0
" let g:ale_sign_error = '→'
" let g:ale_sign_warning = '→'
" " let g:ale_fix_on_save = 1
" let g:ale_elixir_elixir_ls_release = $HOME . './elixir_ls'

" let g:ale_linters = {
"       \ 'elixir': [],
"       \ }

" let g:ale_fixers = {
"       \  'elixir': ['mix_format'],
"       \  'javascript': ['standard'],
"       \}

" nnoremap <localleader>f :ALEFix<cr>

" highlight ALEError ctermfg=01 ctermbg=18
" highlight AleWarning ctermfg=blue ctermbg=black
" highlight ALEStyleWarningSign ctermfg=yellow ctermbg=black
" highlight ALEWarningSign ctermfg=yellow ctermbg=black
" highlight ALEErrorSign ctermfg=red ctermbg=black
" highlight ALEStyleErrorSign ctermfg=red ctermbg=black

"---------------------------------------
" PLUGIN: UltiSnips
"---------------------------------------

let g:UltiSnipsSnippetDirectories=["custom-snippets"]
let g:UltiSnipsExpandTrigger="<C-e>"
let g:UltiSnipsJumpForwardTrigger="<C-j>"
let g:UltiSnipsJumpBackwardTrigger="<C-p>"

"---------------------------------------
" PLUGIN: FZF
"---------------------------------------

let $FZF_DEFAULT_COMMAND = 'rg --files --hidden'
let $FZF_DEFAULT_OPTS='--layout=reverse --bind ctrl-a:select-all'

command! -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction

command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)

function! PhoenixWebDir(name)
  let projectname = substitute(getcwd(), '^.*/', '', '')
  let path = 'lib/' . projectname . '_web/' . a:name . '/'
  call fzf#vim#files(path)
endfunction

function! PhoenixDir()
  let projectname = substitute(getcwd(), '^.*/', '', '')
  let path = 'lib/' . projectname . '/
  call fzf#vim#files(path)
endfunction

nmap <localleader>e :Files<CR>
nmap <localleader>v :call PhoenixWebDir('views')<CR>
nmap <localleader>c :call PhoenixWebDir('controllers')<CR>
nmap <localleader>t :call PhoenixWebDir('templates')<CR>
nmap <localleader>m :call PhoenixDir()<CR>
nmap <localleader>r :Files priv/repo/<CR>
nmap <localleader>a :Files assets/<CR>
nmap <localleader>s :RG<CR>

"---------------------------------------
" PLUGIN: vimwiki
"---------------------------------------

let g:vimwiki_global_ext = 0
let g:vimwiki_list = [{'path': '~/vimwiki/', 'syntax': 'markdown', 'ext': '.wiki'}]
