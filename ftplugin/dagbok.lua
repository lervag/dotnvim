vim.o.hlsearch = false
vim.opt_local.formatoptions:remove "n"
vim.wo.signcolumn = "no"
vim.wo.foldmethod = "expr"
vim.wo.foldexpr = "getline(v:lnum) =~# '^\\d' ? '>1' : '1'"

vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "dagbok.txt",
  once = true,
  command = [[silent! normal {,tlzv]]
})

for lhs, rhs in pairs({
  [",t"] = [[/\C\%18c \?x<cr>]],
  [",n"] = "Gonew<c-r>=UltiSnips#ExpandSnippet()<cr>",
}) do
  vim.keymap.set("n", lhs, rhs, { buffer = true, silent = true })
end
vim.keymap.set("n", ",a", "zRgg/^2006-<cr>?^200<cr>k2yy}Pj$<c-a>oadd", {
  buffer = true,
  remap = true
})
