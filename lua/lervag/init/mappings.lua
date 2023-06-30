-- Use space as leader key
vim.g.mapleader = " "

-- Ting jeg kan bruke i maps
-- <cr> (forsiktig med wiki.vim-konflikt)

vim.keymap.set({ "n", "i" }, "<f1>", "<nop>")
vim.keymap.set("n", "<space>", "<nop>")

vim.keymap.set("n", "Y", "y$")
vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "dp", "dp]c")
vim.keymap.set("n", "do", "do]c")
vim.keymap.set("n", "'", "`")
vim.keymap.set("n", "<c-e>", "      <c-^>")
vim.keymap.set("n", "<c-w><c-e>", " <c-w><c-^>")
vim.keymap.set({ "n", "x" }, "j", function()
  return vim.v.count > 1 and "j" or "gj"
end, { expr = true })
vim.keymap.set({ "n", "x" }, "k", function()
  return vim.v.count > 1 and "k" or "gk"
end, { expr = true })
vim.keymap.set("n", "gV", "`[V`]")
vim.keymap.set("o", "gV", "<cmd>normal gV<cr>")
vim.keymap.set("o", "gv", "<cmd>normal! gv<cr>")
vim.keymap.set("n", "zS", "<cmd>Inspect<cr>")
vim.keymap.set("n", "<c-w>-", "    <c-w>s")
vim.keymap.set("n", "<c-w><bar>", "<c-w>v")
vim.keymap.set("n", "<c-w>§", "    <c-w><bar>")
vim.keymap.set("n", "<f3>", "<cmd>call personal#spell#toggle_language()<cr>")
vim.keymap.set("n", "y@", "<cmd>call personal#util#copy_path()<cr>")

-- Navigation
vim.keymap.set("n", "gb", "<cmd>bnext<cr>", { silent = true })
vim.keymap.set("n", "gB", "<cmd>bprevious<cr>", { silent = true })
vim.keymap.set("n", "zv", "zMzvzz")
vim.keymap.set("n", "zj", "zcjzOzz")
vim.keymap.set("n", "zk", "zckzOzz")

-- Simple math stuff
vim.keymap.set("x", "++", function()
  return vim.fn["personal#visual_math#yank_and_analyse"]()
end, { silent = true, expr = true })
vim.keymap.set("n", "++", "vip++<esc>", { remap = true })

-- Terminal mappings
vim.keymap.set(
  "n",
  "<c-c><c-c>",
  "<cmd>split term://zsh<cr>i",
  { silent = true }
)
vim.keymap.set("t", "<esc>", "<c-\\><c-n>")
vim.keymap.set("t", "<c-w>", "<c-\\><c-n><c-w>")

-- Utility maps for repeatable quickly change/delete current word
vim.keymap.set("n", "c*", "*``cgn")
vim.keymap.set("n", "c#", "*``cgN")
vim.keymap.set("n", "cg*", "g*``cgn")
vim.keymap.set("n", "cg#", "g*``cgN")
vim.keymap.set("n", "d*", "*``dgn")
vim.keymap.set("n", "d#", "*``dgN")
vim.keymap.set("n", "dg*", "g*``dgn")
vim.keymap.set("n", "dg#", "g*``dgN")
vim.keymap.set("n", "<bs>", "ciw")

-- Improved search related mappings
vim.keymap.set("n", "gl", "<cmd>set nohlsearch<cr>")
vim.keymap.set({ "n", "o" }, "n", function()
  return vim.fn["personal#search#wrap"] "n"
end, { expr = true })
vim.keymap.set({ "n", "o" }, "N", function()
  return vim.fn["personal#search#wrap"] "N"
end, { expr = true })
vim.keymap.set({ "n", "o" }, "gd", function()
  return vim.fn["personal#search#wrap"] "gd"
end, { expr = true })
vim.keymap.set({ "n", "o" }, "gD", function()
  return vim.fn["personal#search#wrap"] "gD"
end, { expr = true })
vim.keymap.set({ "n", "o" }, "*", function()
  return vim.fn["personal#search#wrap"]("*", 1)
end, { expr = true })
vim.keymap.set({ "n", "o" }, "#", function()
  return vim.fn["personal#search#wrap"]("#", 1)
end, { expr = true })
vim.keymap.set({ "n", "o" }, "g*", function()
  return vim.fn["personal#search#wrap"]("g*", 1)
end, { expr = true })
vim.keymap.set({ "n", "o" }, "g#", function()
  return vim.fn["personal#search#wrap"]("g#", 1)
end, { expr = true })
vim.keymap.set("c", "<cr>", function()
  return vim.fn["personal#search#wrap"] "<cr>"
end, { expr = true })
vim.keymap.set("x", "*", function()
  return vim.fn["personal#search#wrap_visual"] "/"
end, { expr = true })
vim.keymap.set("x", "#", function()
  return vim.fn["personal#search#wrap_visual"] "?"
end, { expr = true })
