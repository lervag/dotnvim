vim.fn["personal#markdown#init"]()

-- Disable minidiff for wiki buffers
vim.b.minidiff_disable = true

vim.opt_local.isfname:remove ","

vim.keymap.set("i", "<c-l>", "LLW", { buffer = true })
vim.keymap.set(
  "i",
  "<c-e>",
  "<plug>(cmpu-jump-forwards)<cr><c-a>LLW<plug>(cmpu-expand)",
  { buffer = true, silent = true, remap = true }
)

vim.keymap.set(
  "n",
  "<leader>ar",
  "<cmd>call medieval#eval()<cr>",
  { buffer = true }
)
