" {{{1 Autocommands

augroup init
  autocmd!

  autocmd BufReadPost * call personal#init#go_to_last_known_position()
  autocmd CmdwinEnter * call personal#init#command_line_win()

  autocmd WinEnter,FocusGained * call personal#init#toggle_cursorline(1)
  autocmd WinLeave,FocusLost   * call personal#init#toggle_cursorline(0)
augroup END

" See also: after/plugin/init_autocmds.vim

" {{{1 Options

set shada=!,'100,<50,s50,h
set inccommand=nosplit

" Basic
set tags=tags;~,.tags;~
set path=.,,
if &modifiable
  set fileformat=unix
endif
set wildignore=*.o
set wildignore+=*~
set wildignore+=*.pyc
set wildignore+=.git/*
set wildignore+=.hg/*
set wildignore+=.svn/*
set wildignore+=*.DS_Store
set wildignore+=CVS/*
set wildignore+=*.mod
set diffopt=internal,filler,vertical,foldcolumn:0,context:4
silent! set diffopt+=indent-heuristic,algorithm:patience
silent! set diffopt+=hiddenoff,closeoff

" Backup, swap and undofile
set noswapfile
set undofile
set backup
set backupdir=$HOME/.local/share/nvim/backup//

" Behaviour
set autochdir
set lazyredraw
set confirm
set hidden
set shortmess=aoOtTF
silent! set shortmess+=cI
set textwidth=79
set nowrap
set linebreak
set comments=n:>
set nojoinspaces
set formatoptions+=ronl1j
set formatlistpat=^\\s*[-*]\\s\\+
set formatlistpat+=\\\|^\\s*(\\(\\d\\+\\\|[a-z]\\))\\s\\+
set formatlistpat+=\\\|^\\s*\\(\\d\\+\\\|[a-z]\\)[:).]\\s\\+
set winaltkeys=no
set mouse=
set gdefault
set updatetime=500

" Completion
set wildmode=longest:full,full
set wildcharm=<c-z>
set complete+=U,s,k,kspell,]
set completeopt=menuone,noinsert,noselect
silent! set pumwidth=35

" Spell checking
set spelllang=en_gb
set thesaurus=$HOME/.config/nvim/spell/thesaurus-en.txt

" Presentation
set list
set listchars=tab:▸\ ,nbsp:␣,trail:\ ,extends:…,precedes:…
set fillchars=fold:\ ,diff:⣿
set matchtime=2
set matchpairs+=<:>
" if !&diff
  set cursorline
" endif
set scrolloff=5
set splitbelow
set splitright
set previewheight=20
set noshowmode

" Folding
set foldcolumn=0
set foldtext=personal#fold#foldtext()
set signcolumn=yes

" Indentation
set softtabstop=-1
set shiftwidth=2
set expandtab
set copyindent
set preserveindent
silent! set breakindent

" Searching and movement
set nostartofline
set ignorecase
set smartcase
set infercase
set showmatch
set tagcase=match

set display=lastline
set virtualedit=block

if executable('ag')
  set grepprg=ag\ --nogroup\ --nocolor
elseif executable('ack-grep')
  set grepprg=ack-grep\ --nocolor
endif

" Printing
set printexpr=personal#print_file(v:fname_in)

" {{{1 Appearance and UI

set winwidth=70
if has('termguicolors')
  set termguicolors
endif
colorscheme my_solarized_lua

call personal#init#cursor()
call personal#init#statusline()
call personal#init#tabline()

" {{{1 Mappings

" Use space as leader key
nnoremap <space> <nop>
let g:mapleader = "\<space>"

noremap  <f1>  <nop>
inoremap <f1>  <nop>

" Some general/standard remappings
nnoremap Y      y$
nnoremap J      mzJ`z
nnoremap dp     dp]c
nnoremap do     do]c
nnoremap '      `
nnoremap <c-e>       <c-^>
nnoremap <c-w><c-e>  <c-w><c-^>
nnoremap <expr> j v:count ? 'j' : 'gj'
nnoremap <expr> k v:count ? 'k' : 'gk'
xnoremap <expr> j v:count ? 'j' : 'gj'
xnoremap <expr> k v:count ? 'k' : 'gk'
nnoremap gV     `[V`]
onoremap gV     :normal gV<cr>
onoremap gv     :normal! gv<cr>
nnoremap zS     :<c-u>TSHighlightCapturesUnderCursor<cr>

nnoremap <c-w>-     <c-w>s
nnoremap <c-w><bar> <c-w>v
nnoremap <c-w>§     <c-w><bar>

" Buffer navigation
nnoremap <silent> gb    :bnext<cr>
nnoremap <silent> gB    :bprevious<cr>

" Navigate folds
nnoremap          zv zMzvzz
nnoremap <silent> zj zcjzOzz
nnoremap <silent> zk zckzOzz

" Backspace and return for improved navigation
nnoremap        <bs> <c-o>zvzz

xnoremap <silent><expr> ++ personal#visual_math#yank_and_analyse()
nmap     <silent>       ++ vip++<esc>

nnoremap <leader>pp :hardcopy<cr>
xnoremap <leader>pp :hardcopy<cr>

" Terminal mappings
tnoremap <esc>    <c-\><c-n>
nnoremap <silent> <c-c><c-c> :split term://zsh<cr>i
tnoremap <c-w>    <c-\><c-n><c-w>

" Utility maps for repeatable quickly change/delete current word
nnoremap c*   *``cgn
nnoremap c#   *``cgN
nnoremap cg* g*``cgn
nnoremap cg# g*``cgN
nnoremap d*   *``dgn
nnoremap d#   *``dgN
nnoremap dg* g*``dgn
nnoremap dg# g*``dgN

" Improved search related mappings
nnoremap <silent> gl :<c-u>set nohlsearch<cr>
cmap <expr> <cr> personal#search#wrap("\<cr>")
map  <expr> n    personal#search#wrap('n')
map  <expr> N    personal#search#wrap('N')
map  <expr> gd   personal#search#wrap('gd')
map  <expr> gD   personal#search#wrap('gD')
map  <expr> *    personal#search#wrap('*', 1)
map  <expr> #    personal#search#wrap('#', 1)
map  <expr> g*   personal#search#wrap('g*', 1)
map  <expr> g#   personal#search#wrap('g#', 1)
xmap <expr> *    personal#search#wrap_visual('/')
xmap <expr> #    personal#search#wrap_visual('?')

" Copy path
nnoremap y@ <cmd>call personal#util#copy_path()<cr>

" {{{1 Configure plugins

" Disable a lot of unnecessary internal plugins
let g:loaded_gzip = 1
let g:loaded_matchit = 1
let g:loaded_matchparen = 1
let g:loaded_tarPlugin = 1
let g:loaded_zipPlugin = 1
let g:loaded_spellfile_plugin = 1
let g:loaded_2html_plugin = 1

" Configure built-in filetype plugins
let g:vimsyn_embed = 'lP'
let g:man_hardwrap = 1
let g:loaded_python_provider = 0
let g:python3_host_prog = '~/.local/venvs/nvim/bin/python'

" Use new filetype.lua mechanism
let g:do_filetype_lua = 1
let g:did_load_filetypes = 0

runtime init/plugins.vim

" }}}1
