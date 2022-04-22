vim.diagnostic.config({
  virtual_text = {
    severity = {min=vim.diagnostic.severity.WARN},
  },
  update_in_insert = false,
  severity_sort = true,
  float = {
    focusable = false,
    style = "minimal",
    border = "rounded",
    source = "if_many",
    header = "",
    prefix = "",
  },
})

vim.fn.sign_define({
  { text = '', name = 'DiagnosticSignError', texthl = 'DiagnosticSignError' },
  { text = '', name = 'DiagnosticSignWarn', texthl = 'DiagnosticSignWarn' },
  { text = '', name = 'DiagnosticSignInfo', texthl = 'DiagnosticSignInfo' },
  { text = '', name = 'DiagnosticSignHint', texthl = 'DiagnosticSignHint' }
})

vim.keymap.set('n', '<leader>qp', vim.diagnostic.goto_prev)
vim.keymap.set('n', '<leader>qn', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>ql', vim.diagnostic.setloclist)
vim.keymap.set('n', '<leader>qq', vim.diagnostic.setqflist)
vim.keymap.set('n', '<leader>qe', vim.diagnostic.open_float)
