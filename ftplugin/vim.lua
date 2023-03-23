vim.wo.foldmethod = "marker"

vim.g.ruby_fold = nil
vim.g.vimsyn_folding = "f"

vim.keymap.set("n", "<leader>xx", "<cmd>Runtime %<cr>", { buffer = true })
vim.keymap.set(
  "x",
  "<leader>xx",
  '"vy:@v<cr>',
  { buffer = true, silent = true }
)
