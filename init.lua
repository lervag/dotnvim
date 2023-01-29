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

local HOME = os.getenv "HOME"

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
vim.opt.backupdir = HOME .. "/.local/share/nvim/backup//"

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
vim.opt.wildcharm = 26 -- char2nr(ctrl-z)
vim.opt.complete:append { "U", "s", "k", "kspell", "]" }
vim.opt.completeopt = { "menuone", "noinsert", "noselect" }
vim.opt.pumwidth = 35

-- Spell checking
vim.opt.spelllang = "en_gb"
vim.opt.thesaurus =  HOME .. "/.config/nvim/spell/thesaurus-en.txt"

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
vim.g.mapleader = " "

vim.keymap.set({"n", "i"}, "<f1>", "<nop>")
vim.keymap.set("n", "<space>", "<nop>")

vim.keymap.set("n", "Y", "y$")
vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "dp", "dp]c")
vim.keymap.set("n", "do", "do]c")
vim.keymap.set("n", "'", "`")
vim.keymap.set("n", "<c-e>", "      <c-^>")
vim.keymap.set("n", "<c-w><c-e>", " <c-w><c-^>")
vim.keymap.set({"n", "x"}, "j", function()
  return vim.v.count > 1 and "j" or "gj"
end, { expr = true })
vim.keymap.set({"n", "x"}, "k", function()
  return vim.v.count > 1 and "k" or "gk"
end, { expr = true })
vim.keymap.set("n", "gV", "`[V`]")
vim.keymap.set("o", "gV", "<cmd>normal gV<cr>")
vim.keymap.set("o", "gv", "<cmd>normal! gv<cr>")
vim.keymap.set("n", "zS", "<cmd>Inspect<cr>")
vim.keymap.set("n", "<c-w>-", "    <c-w>s")
vim.keymap.set("n", "<c-w><bar>", "<c-w>v")
vim.keymap.set("n", "<c-w>§", "    <c-w><bar>")
vim.keymap.set("n", "<f3>",
  "<cmd>call personal#spell#toggle_language()<cr>")
vim.keymap.set("n", "y@",
  "<cmd>call personal#util#copy_path()<cr>")

-- Navigation
vim.keymap.set("n", "gb", "<cmd>bnext<cr>", { silent = true })
vim.keymap.set("n", "gB", "<cmd>bprevious<cr>", { silent = true })
vim.keymap.set("n", "zv", "zMzvzz")
vim.keymap.set("n", "zj", "zcjzOzz")
vim.keymap.set("n", "zk", "zckzOzz")
vim.keymap.set("n", "<bs>", "<c-o>zvzz")

-- Simple math stuff
vim.keymap.set("x", "++", function()
  return vim.fn["personal#visual_math#yank_and_analyse"]()
end, { silent = true, expr = true })
vim.keymap.set("n", "++", "vip++<esc>", { remap = true })

-- Terminal mappings
vim.keymap.set("n", "<c-c><c-c>", "<cmd>split term://zsh<cr>i",
  { silent = true })
vim.keymap.set("t", "<esc>", "<c-\\><c-n>")
vim.keymap.set("t", "<c-w>", "<c-\\><c-n><c-w>")

-- Utility maps for repeatable quickly change/delete current word
vim.keymap.set("n", "c*",   "*``cgn")
vim.keymap.set("n", "c#",   "*``cgN")
vim.keymap.set("n", "cg*", "g*``cgn")
vim.keymap.set("n", "cg#", "g*``cgN")
vim.keymap.set("n", "d*",   "*``dgn")
vim.keymap.set("n", "d#",   "*``dgN")
vim.keymap.set("n", "dg*", "g*``dgn")
vim.keymap.set("n", "dg#", "g*``dgN")

-- Improved search related mappings
vim.keymap.set("n", "gl", "<cmd>set nohlsearch<cr>")
vim.keymap.set({"n", "o"}, "n", function() return vim.fn["personal#search#wrap"]("n") end, { expr = true })
vim.keymap.set({"n", "o"}, "N", function() return vim.fn["personal#search#wrap"]("N") end, { expr = true })
vim.keymap.set({"n", "o"}, "gd", function() return vim.fn["personal#search#wrap"]("gd") end, { expr = true })
vim.keymap.set({"n", "o"}, "gD", function() return vim.fn["personal#search#wrap"]("gD") end, { expr = true })
vim.keymap.set({"n", "o"}, "*", function() return vim.fn["personal#search#wrap"]("*", 1) end, { expr = true })
vim.keymap.set({"n", "o"}, "#", function() return vim.fn["personal#search#wrap"]("#", 1) end, { expr = true })
vim.keymap.set({"n", "o"}, "g*", function() return vim.fn["personal#search#wrap"]("g*", 1) end, { expr = true })
vim.keymap.set({"n", "o"}, "g#", function() return vim.fn["personal#search#wrap"]("g#", 1) end, { expr = true })
vim.keymap.set("c", "<cr>", function() return vim.fn["personal#search#wrap"]("<cr>") end, { expr = true })
vim.keymap.set("x", "*", function() return vim.fn["personal#search#wrap_visual"]("/") end, { expr = true })
vim.keymap.set("x", "#", function() return vim.fn["personal#search#wrap_visual"]("?") end, { expr = true })

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

-- vim:fdm=marker
