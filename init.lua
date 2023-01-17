-- {{{1 Autocommands

group = vim.api.nvim_create_augroup("init", { clear = true })
vim.api.nvim_create_autocmd("BufReadPost", {
  group = group,
  pattern = "*",
  desc = "Go to last known position on buffer open",
  command = [[ call personal#init#go_to_last_known_position() ]]
})
vim.api.nvim_create_autocmd("CmdWinEnter", {
  group = group,
  pattern = "*",
  desc = "Set CmdLineWin mappings/options",
  command = [[ call personal#init#command_line_win() ]]
})
vim.api.nvim_create_autocmd({"WinEnter", "FocusGained"}, {
  group = group,
  pattern = "*",
  desc = "Toggle cursorline on enter",
  command = [[ call personal#init#toggle_cursorline(1) ]]
})
vim.api.nvim_create_autocmd({"WinLeave", "FocusLost"}, {
  group = group,
  pattern = "*",
  desc = "Toggle cursorline on leave",
  command = [[ call personal#init#toggle_cursorline(0) ]]
})

-- See also: after/plugin/init_autocmds.vim

-- {{{1 Options

vim.opt.shada = { "!", "'10000", "<50", "s50", "h" }
vim.opt.inccommand = "nosplit"
vim.opt.tags = { "tags;~", ".tags;~" }
vim.opt.path = ".,,"
vim.opt.wildignore:append {
  "*.o",
  "*.mod",
  "*.pyc",
  "*~",
  "*.DS_Store",
  ".git/*",
  ".hg/*",
  ".svn/*",
  "CVS/*"
}
vim.opt.diffopt = {
  "internal",
  "filler",
  "vertical",
  "foldcolumn:0",
  "context:4",
  "indent-heuristic,algorithm:patience",
  "hiddenoff,closeoff",
  "linematch:60",
}

-- Backup, swap and undofile
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.backup = true
vim.opt.backupdir = "$HOME/.local/share/nvim/backup//"

-- Behaviour
vim.opt.lazyredraw = true
vim.opt.confirm = true
vim.opt.hidden = true
vim.opt.shortmess = "aoOtTFcI"
vim.opt.textwidth = 79
vim.opt.wrap = false
vim.opt.linebreak = true
vim.opt.comments = "n:>"
vim.opt.joinspaces = false
vim.opt.formatoptions:append "ronl1j"
vim.opt.formatlistpat =
     [[^\s*[-*]\s\+]]
  .. [[\|^\s*(\(\d\+\|[a-z]\))\s\+]]
  .. [[\|^\s*\(\d\+\|[a-z]\)[:).]\s\+]]
vim.opt.winaltkeys = "no"
vim.opt.mouse = ""
vim.opt.gdefault = true
vim.opt.updatetime = 500
vim.opt.splitkeep = "screen"

-- Completion
vim.opt.wildmode = { "longest:full", "full" }
vim.opt.wildcharm = vim.fn.char2nr ""
vim.opt.complete:append { "U", "s", "k", "kspell", "]" }
vim.opt.completeopt = { "menuone", "noinsert", "noselect" }
vim.opt.pumwidth = 35

-- Spell checking
vim.opt.spelllang = "en_gb"
vim.opt.thesaurus = "$HOME/.config/nvim/spell/thesaurus-en.txt"

-- Presentation
vim.opt.list = true
vim.opt.listchars = {
  tab = "▸ ",
  nbsp = "␣",
  trail = " ",
  extends = "…",
  precedes = "…"
}
vim.opt.fillchars = { fold = " ", diff = "╱" }
vim.opt.matchtime = 2
vim.opt.matchpairs:append "<:>"
vim.opt.cursorline = true
vim.opt.scrolloff = 5
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.previewheight = 20
vim.opt.showmode = false

-- Folding
vim.opt.foldcolumn = "0"
vim.opt.foldtext = "personal#fold#foldtext()"
vim.opt.signcolumn = "yes"

-- Indentation
vim.opt.softtabstop = -1
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.copyindent = true
vim.opt.preserveindent = true
vim.opt.breakindent = true

-- Searching and movement
vim.opt.startofline = false
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.infercase = true
vim.opt.showmatch = true
vim.opt.tagcase = "match"

vim.opt.display = "lastline"
vim.opt.virtualedit = "block"

-- {{{1 Appearance and UI

vim.opt.winwidth = 70
vim.opt.termguicolors = true

vim.cmd.colorscheme "my_solarized_lua"

vim.fn["personal#init#cursor"]()
vim.fn["personal#init#statusline"]()
vim.fn["personal#init#tabline"]()

-- {{{1 Mappings

-- Use space as leader key
vim.keymap.set("n", "<space>", "<nop>")
vim.g.mapleader = " "

vim.keymap.set({"n", "i"}, "<f1>", "<nop>")

vim.cmd [[
" Some general/standard remappings
nnoremap Y      y$
nnoremap J      mzJ`z
nnoremap dp     dp]c
nnoremap do     do]c
nnoremap '      `
nnoremap <c-e>       <c-^>
nnoremap <c-w><c-e>  <c-w><c-^>
nnoremap <expr> j v:count ? "j" : "gj"
nnoremap <expr> k v:count ? "k" : "gk"
xnoremap <expr> j v:count ? "j" : "gj"
xnoremap <expr> k v:count ? "k" : "gk"
nnoremap gV     `[V`]
onoremap gV     :normal gV<cr>
onoremap gv     :normal! gv<cr>
nnoremap zS     :<c-u>Inspect<cr>

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
map  <expr> n    personal#search#wrap("n")
map  <expr> N    personal#search#wrap("N")
map  <expr> gd   personal#search#wrap("gd")
map  <expr> gD   personal#search#wrap("gD")
map  <expr> *    personal#search#wrap("*", 1)
map  <expr> #    personal#search#wrap("#", 1)
map  <expr> g*   personal#search#wrap("g*", 1)
map  <expr> g#   personal#search#wrap("g#", 1)
xmap <expr> *    personal#search#wrap_visual("/")
xmap <expr> #    personal#search#wrap_visual("?")

" Copy path
nnoremap y@ <cmd>call personal#util#copy_path()<cr>

nnoremap <f3> <cmd>:call personal#spell#toggle_language()<cr>
]]

-- {{{1 Configure plugins

-- Disable a lot of unnecessary internal plugins
vim.g.loaded_gzip = 1
vim.g.loaded_matchit = 1
vim.g.loaded_matchparen = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_spellfile_plugin = 1
vim.g.loaded_2html_plugin = 1

-- Configure built-in filetype plugins
vim.g.vimsyn_embed = "lP"
vim.g.man_hardwrap = 1
vim.g.loaded_python_provider = 0
vim.g.python3_host_prog = "~/.local/venvs/nvim/bin/python"

vim.cmd.runtime "init/plugins.vim"

-- }}}1