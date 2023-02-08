vim.opt_local.textwidth = 0
vim.opt_local.wrap = true

vim.keymap.set("n", "<cr>", "<plug>(vimtex-context-menu)", { buffer = true })
vim.keymap.set("n", "K", "<plug>(vimtex-doc-package)", { buffer = true })
