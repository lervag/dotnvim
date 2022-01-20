require("gomove").setup {
  map_defaults = false,
  move_past_end_col = true,
}

vim.keymap.set("n", "<left>",    "<plug>GoNSMLeft")
vim.keymap.set("n", "<down>",    "<plug>GoNSMDown")
vim.keymap.set("n", "<up>",      "<plug>GoNSMUp")
vim.keymap.set("n", "<right>",   "<plug>GoNSMRight")

vim.keymap.set("x", "<left>",    "<plug>GoVSMLeft")
vim.keymap.set("x", "<down>",    "<plug>GoVSMDown")
vim.keymap.set("x", "<up>",      "<plug>GoVSMUp")
vim.keymap.set("x", "<right>",   "<plug>GoVSMRight")
