-- Disable a lot of unnecessary internal plugins
vim.g.loaded_gzip = 1
vim.g.loaded_matchit = 1
vim.g.loaded_matchparen = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_spellfile_plugin = 1
vim.g.loaded_2html_plugin = 1

-- Configure built-in filetype plugins
vim.g.vimsyn_embed = "lP"
vim.g.man_hardwrap = 1
vim.g.loaded_python_provider = 0
vim.g.python3_host_prog = "~/.local/venvs/nvim/bin/python"

vim.cmd.runtime "init/plugins.vim"
