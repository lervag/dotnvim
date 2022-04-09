leap = require('leap')

local opts = { noremap=true, silent=true }
vim.keymap.set('n', 's', '<plug>(leap-omni)', opts)
vim.keymap.set('x', 'x', '<plug>(leap-omni)', opts)
vim.keymap.set('o', 'x', '<plug>(leap-forward-x)', opts)
vim.keymap.set('o', 'X', '<plug>(leap-backward-x)', opts)
vim.keymap.set('o', 'z', '<plug>(leap-forward)', opts)
vim.keymap.set('o', 'Z', '<plug>(leap-backward)', opts)
