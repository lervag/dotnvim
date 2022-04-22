-- This sets up the internal language server interface
-- See also: plugins/nvim-lspconfig.lua

local lsp = vim.lsp

lsp.handlers["textDocument/hover"] = lsp.with(
  lsp.handlers.hover, { border = "double" })
lsp.handlers["textDocument/signatureHelp"] = lsp.with(
  lsp.handlers.signature_help, { border = "double" })

local opts = { silent=true }
vim.keymap.set('n', '<leader>ld', lsp.buf.definition, opts)
vim.keymap.set('n', '<leader>lD', lsp.buf.declaration, opts)
vim.keymap.set('n', '<leader>lt', lsp.buf.type_definition, opts)
vim.keymap.set('n', '<leader>lr', lsp.buf.references, opts)
vim.keymap.set('n', '<leader>li', lsp.buf.implementation, opts)
vim.keymap.set('n', '<leader>lk', lsp.buf.signature_help, opts)
vim.keymap.set('n', '<leader>lR', lsp.buf.rename, opts)
vim.keymap.set('n', '<leader>la', lsp.buf.code_action, opts)
vim.keymap.set('n', '<leader>lc', lsp.codelens.run, opts)
vim.keymap.set('n', '<leader>lf', lsp.buf.formatting, opts)
vim.keymap.set('n', '<leader>lw', function ()
  print(vim.inspect(lsp.buf.list_workspace_folders()))
end, opts)

-- Unsure if I want/need these
vim.keymap.set('n', '<leader>l1', lsp.buf.document_symbol, opts)
vim.keymap.set('n', '<leader>l2', lsp.buf.workspace_symbol, opts)
vim.keymap.set('n', '<leader>l3', lsp.buf.document_highlight, opts)
