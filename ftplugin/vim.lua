-- vim.wo.foldmethod = "marker"
vim.wo.foldmethod = "expr"
vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"

vim.g.ruby_fold = nil
vim.g.vimsyn_folding = "f"
