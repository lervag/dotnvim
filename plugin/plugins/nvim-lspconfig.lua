-- This sets up language servers with nvim-lspconfig
-- See also: ../lsp.lua

-- autocompletion with snippet support
local flags = {
  debounce_text_changes = 150,
}

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true


local function compl_attach(client, bufnr, fuzzy)
  require('lsp_compl').attach(client, bufnr, { trigger_on_delete = true, server_side_fuzzy_completion = fuzzy })
end


local lc = require 'lspconfig'

lc.pyright.setup {
  flags = flags,
  capabilities = capabilities,
  on_attach = function(client, bufnr)
    compl_attach(client, bufnr, false)
  end,
}
