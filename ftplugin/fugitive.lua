vim.keymap.set("n", "q", "<cmd>bwipeout!<cr>", { buffer = true })
vim.keymap.set(
  "n",
  "<f5>",
  "<cmd>call fugitive#ReloadStatus(-1, 0)<cr>",
  { buffer = true }
)
