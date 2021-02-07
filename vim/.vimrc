"---------------------------------------
" BASICS
"---------------------------------------

set nocompatible
filetype plugin indent on
syntax on

let g:mapleader = ' '
let g:maplocalleader = ','

runtime macros/matchit.vim

set backspace=indent,eol,start
set cursorline
set display+=lastline
set encoding=utf-8
set expandtab
set foldlevelstart=50 " open files with all folds open
set foldmethod=syntax
set gdefault
set hidden
set laststatus=2
set lazyredraw
set list listchars=tab:»·,trail:·,nbsp:·|
set nobackup
set nojoinspaces
set noswapfile
set nowritebackup
set scrolloff=999
set shiftround
set shiftwidth=4
set showtabline=2
set sidescroll=1
set sidescrolloff=5
set smartindent
set smarttab
set smarttab
set softtabstop=4
set splitbelow
set splitright
set timeoutlen=500
set ttimeoutlen=0
set updatetime=200
set visualbell

set encoding=utf-8
scriptencoding utf-8

let g:netrw_localrmdir='rm -r'
let g:netrw_banner=0

"
" Persistent undos
set undodir=$HOME/.vim_undos
set undofile
set undolevels=1000
set undoreload=1000
set history=50

"
" Save all when focus is lost
au FocusLost * :silent! wall

"
" Wildmenu
set wildmenu
set wildmode=list:longest
set wildignore=.hg,.svn,*~,*.png,*.jpg,*.gif,*.settings,Thumbs.db,*.min.js,*.swp,publish/*,intermediate/*,*.o,*.hi,Zend,vendor

"
" Format options
set formatoptions=tc " Wrap text and comments using textwidth
set formatoptions+=r " Continue comments when pressing ENTER in insert mode
set formatoptions+=q " Enable formatting of comments with gq
set formatoptions+=n " Detect lists for formatting
set formatoptions+=b " Auto-wrap in insert mode, and do not wrap old long lines

"
" search
set hlsearch " Highlight matches
set incsearch " Search incrementally
set ignorecase " Turn off case sensitivity when searching…
set smartcase " …unless there's a capital letter included

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

"
" UI Features
Plug 'jonathanfilip/vim-lucius'
Plug 'machakann/vim-highlightedyank'
Plug 'tpope/vim-vinegar'

"
" Unit testing
Plug 'janko-m/vim-test', { 'on': ['TestFile', 'TestLast', 'TestNearest', 'TestSuite', 'TestVisit'] }
Plug 'tpope/vim-dispatch'

"
" Find & replace
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'jremmen/vim-ripgrep'

"
" Editor features
Plug 'SirVer/ultisnips'
Plug 'ackyshake/VimCompletesMe'
Plug 'chip/vim-fat-finger'
Plug 'christoomey/vim-tmux-navigator'
Plug 'dense-analysis/ale'
Plug 'derekprior/vim-trimmer'
Plug 'duggiefresh/vim-easydir'
Plug 'justinmk/vim-sneak'
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

"
" vim-test
let test#strategy = 'dispatch'
map <leader>sr :TestSuite<CR>
map <leader>ss :TestNearest<CR>
map <leader>sf :TestFile<CR>
map <leader>sl :TestLast<CR>

"
" ripgrep
if executable('rg')
  " use Ripgrep over Grep
  set grepprg="rg --color never --no-heading"
endif

"
" unfog.vim
nmap <leader>u :Unfog<cr>
nmap <leader>U :tabnew Unfog<cr>

"---------------------------------------
" STATUSLINE
"---------------------------------------

set statusline=%<%f\ (%{&ft})\ %-4(%m%)%=%-19(%3l,%02c%03V%)

"---------------------------------------
" COLOURS
"---------------------------------------

let g:lucius_no_term_bg = 1
colorscheme lucius
LuciusDark

"
" https://github.com/powerline/fonts/blob/master/Inconsolata/Inconsolata%20for%20Powerline.otf
set guifont=InconsolataForPowerline:h14

"
" highlight ale
" highlight ALEError ctermfg=01 ctermbg=18
" highlight AleWarning ctermfg=blue ctermbg=black
" highlight ALEStyleWarningSign ctermfg=yellow ctermbg=black
" highlight ALEWarningSign ctermfg=yellow ctermbg=black
" highlight ALEErrorSign ctermfg=red ctermbg=black
" highlight ALEStyleErrorSign ctermfg=red ctermbg=black

"---------------------------------------
" MAPPINGS
"---------------------------------------

"
" Escaping
inoremap jk <esc>

"
" Move up/down by visual line
noremap j gj
noremap k gk

"
" Quitting & writing buffers & tabs
nmap <leader>q :bp <bar> bd #<cr>
nnoremap <C-q> :tabc<cr>
nnoremap <leader>k :w<cr>

"
" Toggle the two most recent buffers
nnoremap <leader><leader> <c-^>

"
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

"
" buffer navigation
nmap <silent> <C-k> :wincmd k<CR>
nmap <silent> <C-j> :wincmd j<CR>
nmap <silent> <C-h> :wincmd h<CR>
nmap <silent> <C-l> :wincmd l<CR>

"
" Grow and shrink splits
nnoremap <leader>0 <c-w>=
nnoremap <leader>= <c-w>999+
nnoremap <leader>- <c-w>999-

"
" EOL / BOL movement
noremap H ^
noremap L $
vnoremap L g_

"
" Turn off search highlights until next search
nnoremap <localleader><space> :nohls<cr>

"
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

"
" Self-explanatory
set pastetoggle=<F2>
imap <C-l> <space>-><space>

"---------------------------------------
" AUTOGROUPS
"---------------------------------------

"
" Keep the cursor line in the middle of the screen
augroup v_center_cursor
  au!

  au BufEnter,WinEnter,VimResized *,*.*
        \ let &scrolloff=winheight(win_getid())/2
augroup END

augroup global
    au!

    " Only show cursor line in the current window and only when in a non-insert mode
    au WinLeave,InsertEnter * set nocursorline
    au WinEnter,InsertLeave * set cursorline
augroup END

"---------------------------------------
" PLUGIN: ALE
"---------------------------------------

let g:ale_sign_column_always = 1
let g:ale_emit_conflict_warnings = 0
let g:ale_sign_error = '→'
let g:ale_sign_warning = '→'
" let g:ale_fix_on_save = 1
let g:ale_elixir_elixir_ls_release = $HOME . './elixir_ls'

let g:ale_linters = {
      \ 'elixir': [],
      \ }

let g:ale_fixers = {
      \  'elixir': ['mix_format'],
      \  'javascript': ['standard'],
      \}

nnoremap <localleader>f :ALEFix<cr>

function! LoadNearestMixFormatter()
  let l:formatters = []
  let l:directory = fnameescape(expand('%:p:h'))

  let l:git_root = system('git rev-parse --show-toplevel')[:-2]

  let l:fmt = findfile('.formatter.exs', l:git_root)

  let g:ale_elixir_mix_format_options = '--dot-formatter ' . l:fmt
endfunction

call LoadNearestMixFormatter()

function! AddLinterIfFileExists(lang, linter, file, lint, fix)
  let l:current = g:ale_linters[a:lang]

  if filereadable(a:file) && index(l:current, a:linter) == -1
    if a:lint
      let g:ale_linters[a:lang] = g:ale_linters[a:lang] + [a:linter]
    endif
    if a:fix
      let g:ale_fixers[a:lang] = g:ale_fixers[a:lang] + [a:linter]
    end
  endif
endfunction


call AddLinterIfFileExists('elixir', 'credo', 'config/.credo.exs', 1, 0)

"---------------------------------------
" PLUGIN: UltiSnips
"---------------------------------------

let g:UltiSnipsSnippetDirectories=["custom-snippets"]
let g:UltiSnipsExpandTrigger="<C-e>"

"---------------------------------------
" PLUGIN: FZF
"---------------------------------------

augroup vimrc_plugin_fzf
  autocmd! FileType fzf
  autocmd  FileType fzf set nonu nornu
augroup END

let g:fzf_command_prefix = 'Fzf'
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }
let g:fzf_commits_log_options = '--graph --color=always --format="%C(auto)%h%d %s %C(blue)%C(bold)%cr%C(white)"'
let $FZF_DEFAULT_OPTS='--layout=reverse --bind ctrl-a:select-all'
let $FZF_DEFAULT_COMMAND = 'rg --files --hidden'

nmap <localleader>e :FzfFiles<CR>
nmap <localleader>s :FzfRg<CR>

"---------------------------------------
" PLUGIN: vimwiki
"---------------------------------------

let g:vimwiki_global_ext = 0
let g:vimwiki_list = [{'path': '~/vimwiki/', 'syntax': 'markdown', 'ext': '.wiki'}]


endfunction


endfunction




