leap = require('leap')

local opts = { noremap=true, silent=true }
vim.keymap.set('n', 's', '<plug>(leap-forward)', opts)
vim.keymap.set('n', 'S', '<plug>(leap-backward)', opts)
vim.keymap.set('x', 'z', '<plug>(leap-forward)', opts)
vim.keymap.set('x', 'Z', '<plug>(leap-backward)', opts)
vim.keymap.set('o', 'z', '<plug>(leap-forward)', opts)
vim.keymap.set('o', 'Z', '<plug>(leap-backward)', opts)
