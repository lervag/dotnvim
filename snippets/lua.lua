local snippets = {
  {
    prefix = "template-vimtex",
    desc = "Template: Minimal init.lua for VimTeX",
    body = [=[
vim.opt.runtimepath:prepend "~/.local/plugged/vimtex"
vim.opt.runtimepath:append "~/.local/plugged/vimtex/after"
vim.cmd [[filetype plugin indent on]]
vim.cmd [[syntax enable]]

vim.keymap.set("n", "q", "<cmd>qall!<cr>")

vim.g.vimtex_view_method = "zathura"
vim.g.vimtex_cache_root = "."
vim.g.vimtex_cache_persistent = false

vim.cmd.edit "test.tex"
]=],
  },
  {
    prefix = "template-wiki",
    desc = "Template: Minimal vimrc for wiki.vim",
    body = [=[
vim.opt.runtimepath:prepend "~/.local/plugged/wiki.vim"
vim.cmd [[filetype plugin indent on]]
vim.cmd [[syntax enable]]

vim.keymap.set("n", "q", "<cmd>qall!<cr>")

vim.g.wiki_root = vim.fn.fnamemodify("wiki", ':p')
vim.g.wiki_cache_root = "."
vim.g.wiki_cache_persistent = false

vim.cmd [[runtime plugin/wiki.vim]]
vim.cmd [[WikiIndex]]
]=],
  },
  {
    prefix = "template-lazy",
    desc = "Template: Minimal init.lua for lazy.nvim",
    body = [[
local root = vim.fn.fnamemodify("./.lazy", ":p")

for _, name in ipairs({ "config", "data", "state", "cache" }) do
  vim.env[("XDG_%s_HOME"):format(name:upper())] = root .. "/" .. name
end

local lazypath = root .. "/plugins/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", lazypath, })
end
vim.opt.runtimepath:prepend(lazypath)

require("lazy").setup({
  "foo/bar",
}, {
  root = root .. "/plugins",
})
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
