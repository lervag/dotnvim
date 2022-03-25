-- This sets up language servers with nvim-lspconfig
-- See also: ../lsp.lua

local lc = require 'lspconfig'

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)


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


-- Other
lc.vimls.setup {
  capabilities = capabilities,
}
lc.bashls.setup {
  capabilities = capabilities,
}
lc.jsonls.setup {
  cmd = { "vscode-json-languageserver", "--stdio" },
  capabilities = capabilities,
}
lc.yamlls.setup {
  capabilities = capabilities,
}
lc.rust_analyzer.setup {
  capabilities = capabilities,
}
lc.cssls.setup {
  capabilities = capabilities,
}
lc.html.setup {
  capabilities = capabilities,
}
-- lc.ltex.setup {}
-- lc.texlab.setup {}
