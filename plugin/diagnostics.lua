vim.diagnostic.config({
  virtual_text = {
    severity = {min=vim.diagnostic.severity.WARN},
  },
  update_in_insert = false,
  severity_sort = true,
})

vim.cmd [[
  sign define DiagnosticSignError text= texthl=DiagnosticSignError linehl= numhl=
  sign define DiagnosticSignWarn  text= texthl=DiagnosticSignWarn linehl= numhl=
  sign define DiagnosticSignInfo  text= texthl=DiagnosticSignInfo linehl= numhl=
  sign define DiagnosticSignHint  text= texthl=DiagnosticSignHint linehl= numhl=
]]

local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<leader>lp', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', '<leader>ln', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<leader>ll', vim.diagnostic.setloclist, opts)
-- vim.diagnostic.setqflist -- all workspace diagnostics
-- vim.diagnostic.setqflist({severity = "E"}) -- all workspace errors
-- vim.diagnostic.setqflist({severity = "W"}) -- all workspace warnings
