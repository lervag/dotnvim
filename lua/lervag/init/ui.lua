vim.opt.winwidth = 70
vim.opt.termguicolors = true

vim.cmd.colorscheme "my_solarized_lua"

vim.fn["personal#init#cursor"]()
vim.fn["personal#init#statusline"]()
vim.fn["personal#init#tabline"]()
