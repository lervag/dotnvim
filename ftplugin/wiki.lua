vim.fn["personal#markdown#init"]()

vim.opt_local.isfname:remove ","

vim.keymap.set("i", "<c-l>", "LLW", { buffer = true })
vim.keymap.set("i", "<c-e>", "<plug>(ultisnips_jump_forward)<cr><c-a>LLW<c-r>=UltiSnips#ExpandSnippet()<cr>", { buffer = true, silent = true })

vim.cmd.runtime "ftplugin/markdown/medieval.vim"
vim.keymap.set("n", "<leader>ar", "<Plug>(medieval-eval)", { buffer = true })
