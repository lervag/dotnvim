if vim.fn.search([[{{{\d\?$]], "nw") > 0
then
  vim.wo.foldmethod = "marker"
else
  vim.wo.foldmethod = "expr"
  vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
end

vim.g.ruby_fold = nil
vim.g.vimsyn_folding = "f"
