for lhs, rhs in pairs({
  ["q"] = "<cmd>bwipeout!<cr>",
  ["<f5>"] = "<cmd>call fugitive#ReloadStatus(-1, 0)<cr>",
}) do
  vim.keymap.set("n", lhs, rhs, { buffer = true })
end
