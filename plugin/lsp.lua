-- This sets up the internal language server interface
-- See also: plugins/nvim-lspconfig.lua

local lsp = vim.lsp

lsp.handlers["textDocument/hover"] = lsp.with(
  lsp.handlers.hover, { border = "double" })
lsp.handlers["textDocument/signatureHelp"] = lsp.with(
  lsp.handlers.signature_help, { border = "double" })

vim.keymap.set('n', '<leader>ld', lsp.buf.definition)
vim.keymap.set('n', '<leader>lD', lsp.buf.declaration)
vim.keymap.set('n', '<leader>lt', lsp.buf.type_definition)
vim.keymap.set('n', '<leader>lr', lsp.buf.references)
vim.keymap.set('n', '<leader>li', lsp.buf.implementation)
vim.keymap.set('n', '<leader>lk', lsp.buf.signature_help)
vim.keymap.set('n', '<leader>lR', lsp.buf.rename)
vim.keymap.set('n', '<leader>la', lsp.buf.code_action)
vim.keymap.set('n', '<leader>lc', lsp.codelens.run)
vim.keymap.set('n', '<leader>lf', lsp.buf.formatting)
vim.keymap.set('n', '<leader>lw', function ()
  print(vim.inspect(lsp.buf.list_workspace_folders()))
end)

-- Unsure if I want/need these
vim.keymap.set('n', '<leader>l1', lsp.buf.document_symbol)
vim.keymap.set('n', '<leader>l2', lsp.buf.workspace_symbol)
vim.keymap.set('n', '<leader>l3', lsp.buf.document_highlight)
vim.keymap.set('n', '<leader>l4', lsp.buf.clear_references)
