require("gomove").setup {
  map_defaults = false,
  move_past_end_col = true,
}

vim.keymap.set("n", "<left>",  "<plug>GoNSMLeft")
vim.keymap.set("n", "<down>",  "<plug>GoNSMDown")
vim.keymap.set("n", "<up>",    "<plug>GoNSMUp")
vim.keymap.set("n", "<right>", "<plug>GoNSMRight")

vim.keymap.set("n", "<c-left>",  "<plug>GoNSDLeft")
vim.keymap.set("n", "<c-down>",  "<plug>GoNSDDown")
vim.keymap.set("n", "<c-up>",    "<plug>GoNSDUp")
vim.keymap.set("n", "<c-right>", "<plug>GoNSDRight")

vim.keymap.set("x", "<left>",  "<plug>GoVSMLeft")
vim.keymap.set("x", "<down>",  "<plug>GoVSMDown")
vim.keymap.set("x", "<up>",    "<plug>GoVSMUp")
vim.keymap.set("x", "<right>", "<plug>GoVSMRight")

vim.keymap.set("x", "<c-left>",  "<plug>GoVSDLeft")
vim.keymap.set("x", "<c-down>",  "<plug>GoVSDDown")
vim.keymap.set("x", "<c-up>",    "<plug>GoVSDUp")
vim.keymap.set("x", "<c-right>", "<plug>GoVSDRight")
