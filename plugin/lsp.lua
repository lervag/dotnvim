-- This sets up the internal language server interface
-- See also: plugins/nvim-lspconfig.lua

local lsp = vim.lsp


local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<leader>ld', lsp.buf.definition, opts)
vim.keymap.set('n', '<leader>lD', lsp.buf.declaration, opts)
vim.keymap.set('n', '<leader>lt', lsp.buf.type_definition, opts)
vim.keymap.set('n', '<leader>lr', lsp.buf.references, opts)
vim.keymap.set('n', '<leader>li', lsp.buf.implementation, opts)
vim.keymap.set('n', '<leader>lk', lsp.buf.signature_help, opts)
vim.keymap.set('n', '<leader>lR', lsp.buf.rename, opts)
vim.keymap.set('n', '<leader>la', lsp.buf.code_action, opts)
vim.keymap.set('n', '<leader>lp', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', '<leader>ln', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<leader>ll', vim.diagnostic.setloclist, opts)
vim.keymap.set('n', '<leader>lw', function ()
  print(vim.inspect(lsp.buf.list_workspace_folders()))
end, opts)
