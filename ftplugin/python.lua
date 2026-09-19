vim.pack.add { "https://github.com/mfussenegger/nvim-dap-python" }

vim.bo.define = [[^\s*\(def\|class\)]]
vim.bo.textwidth = 0

vim.wo.colorcolumn = "+1"
vim.wo.foldmethod = "expr"
vim.wo.foldexpr = vim.treesitter.foldexpr

require("dap-python").setup "/home/lervag/.local/venvs/nvim/bin/python"
