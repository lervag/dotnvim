leap = require('leap')

vim.keymap.set('n', 's', '<plug>(leap-forward)')
vim.keymap.set('n', 'S', '<plug>(leap-backward)')
vim.keymap.set('x', 'z', '<plug>(leap-forward)')
vim.keymap.set('x', 'Z', '<plug>(leap-backward)')
vim.keymap.set('o', 'z', '<plug>(leap-forward)')
vim.keymap.set('o', 'Z', '<plug>(leap-backward)')
