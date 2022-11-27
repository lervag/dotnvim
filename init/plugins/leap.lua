opts = require('leap').opts
opts.case_sensitive = true
opts.labels = {
    "s", "f", "n", "j", "k",
    "l", "o", "d", "w", "e",
    "h", "m", "v", "g", "u",
    "t", "c", ".", "z"
  }
opts.safe_labels = {}

vim.keymap.set('n', 's', '<plug>(leap-forward)')
vim.keymap.set('n', 'S', '<plug>(leap-backward)')
vim.keymap.set('x', 'z', '<plug>(leap-forward)')
vim.keymap.set('x', 'Z', '<plug>(leap-backward)')
vim.keymap.set('o', 'z', '<plug>(leap-forward)')
vim.keymap.set('o', 'Z', '<plug>(leap-backward)')
