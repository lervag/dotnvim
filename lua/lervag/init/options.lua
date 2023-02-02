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
vim.opt.backupdir = vim.env.HOME .. "/.local/share/nvim/backup//"

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
vim.opt.thesaurus =  vim.env.HOME .. "/.config/nvim/spell/thesaurus-en.txt"

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
