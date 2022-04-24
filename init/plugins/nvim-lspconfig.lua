-- This sets up language servers with nvim-lspconfig
-- See also: ../lsp.lua

local lc = require 'lspconfig'

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)


-- Lua
-- https://github.com/sumneko/lua-language-server
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#sumneko_lua
local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, 'lua/?.lua')
table.insert(runtime_path, 'lua/?/init.lua')

lc.sumneko_lua.setup {
  capabilities = capabilities,
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
        path = runtime_path,
      },
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
  capabilities = capabilities,
}

-- Kotlin
-- https://github.com/fwcd/kotlin-language-server
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#kotlin_language_server
lc.kotlin_language_server.setup {
  capabilities = capabilities,
  handlers = {
    ["textDocument/publishDiagnostics"] = function() end
  }
}

-- Java
-- https://github.com/georgewfraser/java-language-server
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#java_language_server
lc.java_language_server.setup {
  cmd = { "java-language-server" },
  capabilities = capabilities,
  handlers = {
    ["textDocument/publishDiagnostics"] = function() end
  }
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
