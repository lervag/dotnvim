
" Use space as leader key
nnoremap <space> <nop>
let g:mapleader = "\<space>"

" {{{1 Autocommands

augroup vimrc_autocommands
  autocmd!

  " Specify some maps for filenames to filetypes
  autocmd BufNewFile,BufRead *pylintrc set filetype=cfg

  " Only use cursorline for current window, except when in diff mode
  autocmd WinEnter,FocusGained * if !&diff | setlocal cursorline | endif
  autocmd WinLeave,FocusLost   * if !&diff | setlocal nocursorline | endif
  autocmd OptionSet diff call personal#init#toggle_diff()

  " When editing a file, always jump to the last known cursor position.
  autocmd BufReadPost * call personal#init#go_to_last_known_position()

  " Set keymapping for command window
  autocmd CmdwinEnter * nnoremap <buffer> q     <c-c><c-c>
  autocmd CmdwinEnter * nnoremap <buffer> <c-f> <c-c>
augroup END

" {{{1 Options

set shada=!,'300,<100,s300,h
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
set shortmess=aoOtT
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
set completeopt=menuone
silent! set completeopt+=noinsert,noselect
silent! set pumwidth=35

" Presentation
set list
set listchars=tab:▸\ ,nbsp:␣,trail:\ ,extends:…,precedes:…
set fillchars=vert:│,fold:\ ,diff:⣿
set matchtime=2
set matchpairs+=<:>
if !&diff
  set cursorline
endif
set scrolloff=5
set splitbelow
set splitright
set previewheight=20
set noshowmode

" Folding
set foldlevelstart=3
set foldcolumn=0
set foldtext=personal#fold#foldtext()

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
silent! colorscheme my_solarized

call personal#init#cursor()
call personal#init#statusline()
call personal#init#tabline()

" {{{1 Mappings

noremap  <f1>  <nop>
inoremap <f1>  <nop>

" Some general/standard remappings
inoremap jk     <esc>
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
nnoremap zS     :<c-u>TSHighlightCapturesUnderCursor<cr>

nnoremap <c-w>-     <c-w>s
nnoremap <c-w><bar> <c-w>v

" Buffer navigation
nnoremap <silent> gb    :bnext<cr>
nnoremap <silent> gB    :bprevious<cr>

" Navigate folds
nnoremap          zv zMzvzz
nnoremap <silent> zj zcjzOzz
nnoremap <silent> zk zckzOzz

" Backspace and return for improved navigation
nnoremap        <bs> <c-o>zvzz

" Shortcuts for some files
nnoremap <silent> <leader>ev :execute 'edit' resolve($MYVIMRC)<cr>
nnoremap <silent> <leader>xv :source $MYVIMRC<cr>
nnoremap <leader>ez :edit ~/.zshrc<cr>

xnoremap <silent><expr> ++ personal#visual_math#yank_and_analyse()
nmap     <silent>       ++ vip++<esc>

nnoremap <leader>pp :hardcopy<cr>
xnoremap <leader>pp :hardcopy<cr>

" Terminal mappings
tnoremap <esc> <c-\><c-n>
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
call personal#search#init()
cmap <expr> <cr> personal#search#wrap("\<cr>")
map  <expr> n    personal#search#wrap('n')
map  <expr> N    personal#search#wrap('N')
map  <expr> gd   personal#search#wrap('gd')
map  <expr> gD   personal#search#wrap('gD')
map  <expr> *    personal#search#wrap('*', {'immobile': 1})
map  <expr> #    personal#search#wrap('#', {'immobile': 1})
map  <expr> g*   personal#search#wrap('g*', {'immobile': 1})
map  <expr> g#   personal#search#wrap('g#', {'immobile': 1})
xmap <expr> *    personal#search#wrap_visual('/')
xmap <expr> #    personal#search#wrap_visual('?')

" {{{1 Configure plugins

" Most plugins are configured in plugin/plugins/*.vim
runtime plugin/plugins.vim

lua require 'plugins.tree-sitter'
lua require 'plugins.zen-mode'


" Disable a lot of unnecessary internal plugins
let g:loaded_2html_plugin = 1
let g:loaded_getscriptPlugin = 1
let g:loaded_gzip = 1
let g:loaded_logipat = 1
let g:loaded_rrhelper = 1
let g:loaded_spellfile_plugin = 1
let g:loaded_tarPlugin = 1
let g:loaded_vimballPlugin = 1
let g:loaded_zipPlugin = 1

" Configure built-in filetype plugins
let g:vimsyn_embed = 'lP'
let g:man_hardwrap = 1
let g:loaded_python_provider = 0
let g:python3_host_prog = '~/.local/venvs/nvim/bin/python'


" Note: More relevant configuration can be found here.
"
" * ~/.config/nvim/ftplugin/python.vim
" * ~/.config/nvim/after/ftplugin/python.vim

" {{{2 plugin: CtrlFS

let g:ctrlsf_indent = 2
let g:ctrlsf_regex_pattern = 1
let g:ctrlsf_position = 'bottom'
let g:ctrlsf_context = '-B 2'
let g:ctrlsf_default_root = 'project+fw'
let g:ctrlsf_populate_qflist = 1
if executable('rg')
  let g:ctrlsf_ackprg = 'rg'
endif

nnoremap         <leader>ff :CtrlSF 
nnoremap <silent><leader>ft :CtrlSFToggle<cr>
nnoremap <silent><leader>fu :CtrlSFUpdate<cr>
vmap     <silent><leader>f  <Plug>CtrlSFVwordExec

" }}}2
" {{{2 plugin: FastFold

" nmap <sid>(DisableFastFoldUpdate) <plug>(FastFoldUpdate)
let g:fastfold_fold_command_suffixes =  ['x', 'X', 'M', 'R']
let g:fastfold_fold_movement_commands = []

" }}}2
" {{{2 plugin: Fzf

let g:fzf_layout = {'window': {'width': 0.9, 'height': 0.85} }
let g:fzf_colors = {
      \ 'fg':      ['fg', 'Normal'],
      \ 'bg':      ['bg', 'Normal'],
      \ 'hl':      ['fg', 'Comment'],
      \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
      \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
      \ 'hl+':     ['fg', 'Statement'],
      \ 'info':    ['fg', 'PreProc'],
      \ 'border':  ['fg', 'Ignore'],
      \ 'prompt':  ['fg', 'Conditional'],
      \ 'pointer': ['fg', 'Exception'],
      \ 'marker':  ['fg', 'Keyword'],
      \ 'spinner': ['fg', 'Label'],
      \ 'header':  ['fg', 'Comment'],
      \}
let g:fzf_preview_window = ''

let g:fzf_mru_no_sort = 1
let g:fzf_mru_max = 1000
let g:fzf_mru_exclude = '\v' . join([
      \ '\.git/',
      \ '\.local/wiki',
      \ '\.cache/',
      \ '^/tmp/',
      \], '|')

function! s:nothing()
endfunction

augroup my_fzf_config
  autocmd!
  autocmd User FzfStatusLine call s:nothing()
  autocmd FileType fzf silent! tunmap <esc>
augroup END

function! MyFiles(...) abort
  let l:dir = a:0 > 0 ? a:1 : FindRootDirectory()
  if empty(l:dir)
    let l:dir = getcwd()
  endif
  let l:dir = substitute(fnamemodify(l:dir, ':p'), '\/$', '', '')

  let l:prompt_dir = len(l:dir) > 15 ? pathshorten(l:dir) : l:dir

  call fzf#vim#files(l:dir, {
      \ 'options': [
      \   '-m',
      \   '--prompt', 'Files ' . l:prompt_dir . '::'
      \ ],
      \})
endfunction

command! -bang Zotero call fzf#run(fzf#wrap(
            \ 'zotero',
            \ { 'source':  'fd -t f -e pdf . ~/.local/zotero/',
            \   'sink':    {x -> system(['zathura', '--fork', x])},
            \   'options': '-m -d / --with-nth=-1' },
            \ <bang>0))

nnoremap <silent> <leader><leader> :FZFFreshMru --prompt "History > "<cr>
nnoremap <silent> <leader>ob       :Buffers<cr>
nnoremap <silent> <leader>ot       :Tags<cr>
nnoremap <silent> <leader>ow       :WikiFzfPages<cr>
nnoremap <silent> <leader>oz       :Zotero<cr>
nnoremap <silent> <leader>oo       :call MyFiles()<cr>
nnoremap <silent> <leader>op       :call MyFiles('~/.local/plugged')<cr>
nnoremap <silent> <leader>ov       :call fzf#run(fzf#wrap({
      \ 'dir': '~/.config/nvim',
      \ 'source': 'git ls-files --exclude-standard --others --cached',
      \ 'options': [
      \   '--prompt', 'Files ~/.config/nvim::',
      \ ],
      \}))<cr>

" }}}2
" {{{2 plugin: lists.vim

let g:lists_filetypes = ['markdown', 'wiki', 'help', 'text']

" }}}2
" {{{2 plugin: targets.vim

let g:targets_argOpening = '[({[]'
let g:targets_argClosing = '[]})]'
let g:targets_separators = ', . ; : + - = ~ _ * # / | \ &'
let g:targets_seekRanges = 'cc cr cb cB lc ac Ac lr lb ar ab lB Ar aB Ab AB rr ll rb al rB Al bb aa bB Aa BB AA'

" }}}2
" {{{2 plugin: UltiSnips

let g:UltiSnipsExpandTrigger = '<nop>'
let g:UltiSnipsJumpForwardTrigger = '<c-j>'
let g:UltiSnipsJumpBackwardTrigger = '<c-k>'
let g:UltiSnipsRemoveSelectModeMappings = 0
let g:UltiSnipsSnippetDirectories = ['~/.config/nvim/UltiSnips']

nnoremap <leader>es :UltiSnipsEdit!<cr>

" }}}2
" {{{2 plugin: undotree

let g:undotree_WindowLayout = 2
let g:undotree_SetFocusWhenToggle = 1

nnoremap <f5> :UndotreeToggle<cr>

" }}}2
" {{{2 plugin: vim-columnmove

let g:columnmove_no_default_key_mappings = 1

for s:x in split('ftFT;,wbeWBE', '\zs') + ['ge', 'gE']
  silent! call columnmove#utility#map('nxo', s:x, 'ø' . s:x, 'block')
endfor
unlet s:x

" }}}2
" {{{2 plugin: vim-easy-align

let g:easy_align_bypass_fold = 1

nmap <leader>ea <plug>(LiveEasyAlign)
vmap <leader>ea <plug>(LiveEasyAlign)
nmap <leader>eA <plug>(EasyAlign)
vmap <leader>eA <plug>(EasyAlign)
vmap .  <plug>(EasyAlignRepeat)

" }}}2
" {{{2 plugin: vim-gutentags

let g:gutentags_define_advanced_commands = 1
let g:gutentags_cache_dir = expand('~/.cache/nvim/ctags/')
let g:gutentags_ctags_extra_args = [
      \ '--tag-relative=yes',
      \ '--fields=+aimS',
      \ ]
let g:gutentags_file_list_command = {
      \ 'markers': {
      \   '.git': 'git ls-files',
      \   '.hg': 'hg files',
      \ },
      \}

" }}}2
" {{{2 plugin: vim-hexokinase

let g:Hexokinase_highlighters = ['backgroundfull']
let g:Hexokinase_ftEnabled = ['css', 'html']

" }}}2
" {{{2 plugin: vim-matchup

let g:matchup_matchparen_status_offscreen = 0
let g:matchup_override_vimtex = 1

" }}}2
" {{{2 plugin: vim-rooter

let g:rooter_manual_only = 1
let g:rooter_patterns = ['.git', '.hg', '.bzr', '.svn']

" }}}
" {{{2 plugin: vim-sandwich

let g:sandwich_no_default_key_mappings = 1
let g:operator_sandwich_no_default_key_mappings = 1
let g:textobj_sandwich_no_default_key_mappings = 1

" Support for python like function names
let g:sandwich#magicchar#f#patterns = [
  \   {
  \     'header' : '\<\%(\h\k*\.\)*\h\k*',
  \     'bra'    : '(',
  \     'ket'    : ')',
  \     'footer' : '',
  \   },
  \ ]


try
  " Change some default options
  call operator#sandwich#set('delete', 'all', 'highlight', 0)
  call operator#sandwich#set('all', 'all', 'cursor', 'keep')

  " Surround mappings (similar to surround.vim)
  nmap gs  <plug>(operator-sandwich-add)
  nmap gss <plug>(operator-sandwich-add)iW
  nmap ds  <plug>(operator-sandwich-delete)<plug>(textobj-sandwich-query-a)
  nmap dss <plug>(operator-sandwich-delete)<plug>(textobj-sandwich-auto-a)
  nmap cs  <plug>(operator-sandwich-replace)<plug>(textobj-sandwich-query-a)
  nmap css <plug>(operator-sandwich-replace)<plug>(textobj-sandwich-auto-a)
  xmap sa  <plug>(operator-sandwich-add)
  xmap sd  <plug>(operator-sandwich-delete)
  xmap sr  <plug>(operator-sandwich-replace)

  " Text objects
  xmap is  <plug>(textobj-sandwich-query-i)
  xmap as  <plug>(textobj-sandwich-query-a)
  omap is  <plug>(textobj-sandwich-query-i)
  omap as  <plug>(textobj-sandwich-query-a)
  xmap iss <plug>(textobj-sandwich-auto-i)
  xmap ass <plug>(textobj-sandwich-auto-a)
  omap iss <plug>(textobj-sandwich-auto-i)
  omap ass <plug>(textobj-sandwich-auto-a)

  " Allow repeats while keeping cursor fixed
  silent! runtime autoload/repeat.vim
  nmap . <plug>(operator-sandwich-predot)<plug>(RepeatDot)

  " Default recipes
  let g:sandwich#recipes  = deepcopy(g:sandwich#default_recipes)
  let g:sandwich#recipes += [
        \ {
        \   'buns' : ['{\s*', '\s*}'],
        \   'input' : ['}'],
        \   'kind' : ['delete', 'replace', 'auto', 'query'],
        \   'regex' : 1,
        \   'nesting' : 1,
        \   'match_syntax' : 1,
        \   'skip_break' : 1,
        \   'indentkeys-' : '{,},0{,0}'
        \ },
        \ {
        \   'buns' : ['\[\s*', '\s*\]'],
        \   'input' : [']'],
        \   'kind' : ['delete', 'replace', 'auto', 'query'],
        \   'regex' : 1,
        \   'nesting' : 1,
        \   'match_syntax' : 1,
        \   'indentkeys-' : '[,]'
        \ },
        \ {
        \   'buns' : ['(\s*', '\s*)'],
        \   'input' : [')'],
        \   'kind' : ['delete', 'replace', 'auto', 'query'],
        \   'regex' : 1,
        \   'nesting' : 1,
        \   'match_syntax' : 1,
        \   'indentkeys-' : '(,)'
        \ },
        \]
catch
endtry

" }}}2
" {{{2 plugin: vim-schlepp

vmap <unique> <up>    <Plug>SchleppUp
vmap <unique> <down>  <Plug>SchleppDown
vmap <unique> <left>  <Plug>SchleppLeft
vmap <unique> <right> <Plug>SchleppRight

" }}}2
" {{{2 plugin: vim-sort-folds

xnoremap <silent> <leader>s :call sortfolds#SortFolds()<cr>

" }}}
" {{{2 plugin: vim-table-mode

let g:table_mode_auto_align = 0
let g:table_mode_corner = '|'

" }}}2
" {{{2 plugin: vim-tmux-navigator

let g:tmux_navigator_disable_when_zoomed = 1

" }}}
" {{{2 plugin: vimux

let g:VimuxOrientation = 'h'
let g:VimuxHeight = '50'
let g:VimuxResetSequence = ''

" Open and manage panes/runners
nnoremap <leader>io :call VimuxOpenRunner()<cr>
nnoremap <leader>iq :VimuxCloseRunner<cr>
nnoremap <leader>ip :VimuxPromptCommand<cr>
nnoremap <leader>in :VimuxInspectRunner<cr>

" Send commands
nnoremap <leader>ii  :VimuxRunCommand 'jkk'<cr>
nnoremap <leader>is  :set opfunc=personal#vimux#operator<cr>g@
nnoremap <leader>iss :call VimuxRunCommand(getline('.'))<cr>
xnoremap <leader>is  "vy :call VimuxSendText(@v)<cr>

" }}}2

" {{{2 filetype: markdown

let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_follow_anchor = 1
let g:vim_markdown_frontmatter = 1
let g:vim_markdown_toml_frontmatter = 1
let g:vim_markdown_new_list_item_indent = 2
let g:vim_markdown_no_extensions_in_markdown = 1
let g:vim_markdown_conceal = 2
let g:vim_markdown_conceal_code_blocks = 0
let g:vim_markdown_math = 1
let g:vim_markdown_strikethrough = 1

" }}}2

" }}}1
