vim.pack.add { "https://github.com/nvim-mini/mini.input" }

local ui_input_orig = vim.ui.input
require("mini.input").setup()
vim.ui.input = ui_input_orig
