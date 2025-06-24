vim.bo.define = [[^\s*\(def\|class\)]]
vim.bo.includeexpr = "personal#python#includexpr()"

vim.wo.colorcolumn = "+1"
vim.wo.foldmethod = "expr"
vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"

vim.fn["personal#python#set_path"]()
