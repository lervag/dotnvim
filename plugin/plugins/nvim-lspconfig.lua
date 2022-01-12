-- This sets up language servers with nvim-lspconfig
-- See also: ../lsp.lua

local function on_attach(_, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

local lc = require 'lspconfig'


-- Lua
-- https://github.com/sumneko/lua-language-server
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#sumneko_lua
lc.sumneko_lua.setup {
  flags = { debounce_text_changes = 150 },
  on_attach = on_attach,
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
  on_attach = on_attach,
}
