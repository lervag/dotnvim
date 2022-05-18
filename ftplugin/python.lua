vim.bo.define = [[^\s*\(def\|class\)]]
vim.wo.colorcolumn = '80'
vim.wo.foldexpr = 'personal#python#foldexpr(v:lnum)'
vim.wo.foldmethod = 'expr'

vim.fn['personal#python#set_path']()
