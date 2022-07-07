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
  { text = '', name = 'DiagnosticSignError', texthl = 'DiagnosticSignError' },
  { text = '', name = 'DiagnosticSignWarn', texthl = 'DiagnosticSignWarn' },
  { text = '', name = 'DiagnosticSignInfo', texthl = 'DiagnosticSignInfo' },
  { text = '', name = 'DiagnosticSignHint', texthl = 'DiagnosticSignHint' }
})

local diagnostics_active = true
local toggle_diagnostics = function()
  diagnostics_active = not diagnostics_active
  if diagnostics_active then
    vim.diagnostic.enable(0)
    vim.diagnostic.show()
    vim.notify("Diagnostics enabled.", vim.log.levels.INFO)
  else
    vim.diagnostic.hide()
    vim.diagnostic.disable(0)
    vim.notify("Diagnostics disabled!", vim.log.levels.INFO, {title = 'Test'})
  end
end

vim.keymap.set('n', '<leader>qq', toggle_diagnostics)
vim.keymap.set('n', '<leader>qp', vim.diagnostic.goto_prev)
vim.keymap.set('n', '<leader>qn', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>qL', vim.diagnostic.setloclist)
vim.keymap.set('n', '<leader>ql', vim.diagnostic.setqflist)
vim.keymap.set('n', '<leader>qe', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>qc', '<cmd>cclose<cr>')
vim.keymap.set('n', '<leader>qC', '<cmd>lclose<cr>')
