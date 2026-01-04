local snippets = {
  {
    prefix = "template-vimtex",
    desc = "Template: Minimal init.lua for VimTeX",
    body = [[
vim.opt.runtimepath:prepend "~/.local/plugged/vimtex"
vim.opt.runtimepath:append "~/.local/plugged/vimtex/after"
vim.cmd.filetype "plugin indent on"
vim.cmd.syntax "enable"

vim.keymap.set("n", "q", "<cmd>qall!<cr>")

vim.g.vimtex_view_method = "zathura"
vim.g.vimtex_cache_root = "."
vim.g.vimtex_cache_persistent = false

vim.cmd.edit "test.tex"
]],
  },
  {
    prefix = "template-wiki",
    desc = "Template: Minimal vimrc for wiki.vim",
    body = [[
vim.opt.runtimepath:prepend "~/.local/plugged/wiki.vim"
vim.cmd.filetype "plugin indent on"
vim.cmd.syntax "enable"

vim.keymap.set("n", "q", "<cmd>qall!<cr>")

vim.g.wiki_root = vim.fn.fnamemodify("wiki", ':p')
vim.g.wiki_cache_root = "."
vim.g.wiki_cache_persistent = false

vim.cmd.runtime "plugin/wiki.vim"
vim.cmd.WikiIndex()
]],
  },
  {
    prefix = "template-mini",
    desc = "Template: Minimal init.lua",
    body = [[
-- To use as minimal init file:
-- XDG_DATA_HOME=. XDG_CONFIG_HOME=. XDG_STATE_HOME=. nvim -u test.lua

vim.pack.add {
  "https://github.com/lervag/vimtex",
  "https://github.com/lervag/wiki.vim",
}

vim.cmd.filetype "plugin indent on"
vim.cmd.syntax "enable"

-- Plugins are now loaded, but plugin/... are not sourced until after this
-- file is finished sourcing.

vim.keymap.set("n", "q", "<cmd>qall!<cr>")

-- Options here
vim.g.options = "foobar"
]],
  },
  {
    prefix = "template-debug",
    desc = "Template for debugging Lua scripts",
    body = [[
if vim.env.DEBUG then
  vim.opt.runtimepath:prepend "~/.local/plugged/one-small-step-for-vimkind"
  require "osv".launch { port = 8086, blocking = true }
end
]],
  },
}

return snippets
