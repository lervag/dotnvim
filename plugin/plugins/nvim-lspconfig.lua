-- This sets up language servers with nvim-lspconfig
-- See also: ../lsp.lua

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

local lc = require 'lspconfig'


-- Lua
-- https://github.com/sumneko/lua-language-server
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#sumneko_lua
lc.sumneko_lua.setup {
  flags = {
    debounce_text_changes = 150,
  },
  on_attach = function(client, bufnr)
    vim.api.nvim_buf_set_option(0, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K',
      '<cmd>lua vim.lsp.buf.hover()<CR>', { noremap=true, silent=true })
  end,
  settings = {
    Lua = {
      workspace = {
        library = vim.api.nvim_get_runtime_file('', true),
        -- maxPreload = 1000,
        -- preloadFileSize = 350,
        -- checkThirdParty = false,
      },
      diagnostics = {
        globals = { 'vim' },
        -- disable = { 'lowercase-global' },
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
  flags = {
    debounce_text_changes = 150,
  },
  capabilities = capabilities,
  on_attach = function(client, bufnr)
    vim.api.nvim_buf_set_option(0, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K',
      '<cmd>lua vim.lsp.buf.hover()<CR>', { noremap=true, silent=true })
    -- compl_attach(client, bufnr, false)
  end,
}
