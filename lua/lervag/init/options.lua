-- {{{1 Misc

vim.opt.shada = { "!", "'10000", "<50", "s50", "h" }
vim.o.inccommand = "nosplit"
vim.opt.tags = { "tags;~", ".tags;~" }
vim.o.path = ".,,"
vim.opt.wildignore:append {
  "*.o",
  "*.mod",
  "*.pyc",
  "*~",
  "*.DS_Store",
  ".git/*",
  ".hg/*",
  ".svn/*",
  "CVS/*",
}
vim.opt.diffopt = {
  "internal",
  "filler",
  "vertical",
  "foldcolumn:0",
  "context:4",
  "indent-heuristic",
  "algorithm:histogram",
  "hiddenoff",
  "closeoff",
  "linematch:60",
  "inline:word",
}

-- {{{1 Backup, swap and undofile

vim.o.swapfile = false
vim.o.undofile = true
vim.o.backup = true
vim.o.backupdir = vim.env.HOME .. "/.local/share/nvim/backup//"

-- {{{1 Behaviour

vim.o.confirm = true
vim.o.hidden = true
vim.o.shortmess = "aoOtTFcCI"
vim.o.textwidth = 79
vim.o.wrap = false
vim.o.linebreak = true
vim.o.comments = "n:>"
vim.o.joinspaces = false
vim.opt.formatoptions:append "ronl1j"
vim.o.formatlistpat = [[^\s*[-*]\s\+]]
  .. [[\|^\s*(\(\d\+\|[a-z]\))\s\+]]
  .. [[\|^\s*\(\d\+\|[a-z]\)[:).]\s\+]]
vim.o.winaltkeys = "no"
vim.o.mouse = ""
vim.o.gdefault = true
vim.o.updatetime = 50
vim.o.splitkeep = "screen"
vim.o.jumpoptions = "stack"

-- {{{1 Completion

vim.opt.wildmode = { "longest:full", "full" }
vim.o.wildcharm = 26 -- char2nr(ctrl-z)
vim.opt.complete:append { "U", "s", "k", "kspell", "]" }
vim.opt.completeopt = { "menuone", "noinsert", "noselect" }
vim.o.pumwidth = 35

-- {{{1 Spell checking

vim.o.spelllang = "en_gb"
vim.o.thesaurus = vim.env.HOME .. "/.config/nvim/spell/thesaurus-en.txt"

-- {{{1 Presentation

vim.o.list = true
vim.opt.listchars = {
  tab = "▸ ",
  nbsp = "␣",
  trail = " ",
  extends = "⋯",
  precedes = "⋯",
}
vim.opt.fillchars = {
  fold = " ",
  diff = "╱",
  foldclose = "╶",
  foldopen = "┌",
  foldsep = "┊",
  vert = "┃",
}
vim.o.matchtime = 2
vim.opt.matchpairs:append "<:>"
vim.o.cursorline = true
vim.o.scrolloff = 5
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.previewheight = 20
vim.o.showmode = false

-- {{{1 Folding

vim.o.foldcolumn = "0"
vim.o.foldtext = ""
vim.o.signcolumn = "auto:1-4" ---@diagnostic disable-line: assign-type-mismatch

-- {{{1 Indentation

vim.o.softtabstop = -1
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.o.copyindent = true
vim.o.preserveindent = true
vim.o.breakindent = true

-- {{{1 Searching and movement

vim.o.startofline = false
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.infercase = true
vim.o.showmatch = true
vim.o.tagcase = "match"

vim.o.display = "lastline"
vim.o.virtualedit = "block"

-- {{{1 UI

-- vim.opt.winborder = "▗,▄,▖,▌,▘,▀,▝,▐"
vim.o.winborder = "solid"
vim.o.winwidth = 70
vim.o.termguicolors = true
vim.o.tabline = "%!v:lua.require('lervag.statusline').tabline()"
vim.o.statusline = "%!v:lua.require('lervag.statusline').statusline()"
vim.opt.guicursor = {
  "a:block",
  "n:Cursor",
  "o-c:iCursor",
  "v:vCursor",
  "i-ci-sm:ver30-iCursor",
  "r-cr:hor20-rCursor",
  "a:blinkon0",
}

vim.cmd.colorscheme "solarized_custom"

-- {{{1 Filetype plugins

vim.g.loaded_gzip = 1
vim.g.loaded_matchit = 1
vim.g.loaded_matchparen = 1
vim.g.loaded_tar = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_zip = 1
vim.g.loaded_zipPlugin = 1

vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python_provider = 0
vim.g.loaded_ruby_provider = 0

vim.g.python3_host_prog = "~/.local/venvs/nvim/bin/python"

vim.g.vimsyn_embed = "lP"
vim.g.man_hardwrap = 1

-- Detect som additional filetypes
vim.filetype.add {
  extension = {
    pf = "fortran",
    wiki = "wiki",
    hujson = "jsonc",
    mdx = "mdx",
  },
  filename = {
    ["dagbok.txt"] = "dagbok",
  },
  pattern = {
    [".*pylintrc"] = "cfg",
    ["Jenkinsfile.*"] = "groovy",
    [".*/%.github[%w/]+workflows[%w/]+.*%.ya?ml"] = "yaml.github",
  },
}

-- vim: fdm=marker
