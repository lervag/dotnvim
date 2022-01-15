-- This sets up language servers with nvim-lspconfig
-- See also: ../lsp.lua

local lc = require 'lspconfig'
local coq = require 'coq'

local capabilities = vim.lsp.protocol.make_client_capabilities()

local function setup(ls, config)
  lc[ls].setup(coq.lsp_ensure_capabilities(config))
end


-- Lua
-- https://github.com/sumneko/lua-language-server
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#sumneko_lua
setup('sumneko_lua', {
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
})

-- Python
-- https://github.com/microsoft/pyright
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#pyright
setup('pyright', {
  flags = { debounce_text_changes = 150 },
  capabilities = capabilities,
})


setup 'vimls'
setup 'bashls'
setup('jsonls', {
  cmd = { "vscode-json-languageserver", "--stdio" }
})
setup 'yamlls'
setup 'rust_analyzer'
setup 'cssls'
setup 'html'
-- 'ltex',
-- 'texlab',
