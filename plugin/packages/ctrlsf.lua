vim.pack.add { "https://github.com/dyng/ctrlsf.vim" }

vim.keymap.set("n", "<leader>ff", ":CtrlSF ")
vim.keymap.set("n", "<leader>ft", "<cmd>CtrlSFToggle<cr>")
vim.keymap.set("n", "<leader>fu", "<cmd>CtrlSFUpdate<cr>")
vim.keymap.set("x", "<leader>ff", "<plug>CtrlSFVwordExec")

vim.g.ctrlsf_indent = 2
vim.g.ctrlsf_regex_pattern = 1
vim.g.ctrlsf_position = "bottom"
vim.g.ctrlsf_context = "-B 2"
vim.g.ctrlsf_default_root = "project+fw"
vim.g.ctrlsf_populate_qflist = 1
vim.g.ctrlsf_extra_backend_args = {
  rg = "--hidden",
}
