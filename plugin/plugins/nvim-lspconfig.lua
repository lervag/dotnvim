-- This sets up language servers with nvim-lspconfig
-- See also: ../lsp.lua

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
capabilities.textDocument.completion.completionItem.deprecatedSupport = true
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

local lc = require 'lspconfig'


-- Lua
-- https://github.com/sumneko/lua-language-server
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#sumneko_lua
lc.sumneko_lua.setup {
  flags = { debounce_text_changes = 150 },
  capabilities = capabilities,
  settings = {
    Lua = {
      workspace = {
        library = vim.api.nvim_get_runtime_file('', true),
      },
      diagnostics = {
        globals = { 'vim' },
        disable = { 'lowercase-global' },
      },
      -- completion = {
      --   callSnippet = 'Replace',
      --   showWord = 'Disable',
      -- },
      telemetry = {
        enable = false,
      },
    },
  },
}

-- Python
-- https://github.com/microsoft/pyright
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#pyright
lc.pyright.setup {
  flags = { debounce_text_changes = 150 },
  capabilities = capabilities,
}
