-- Configuration for Sumneko Lua LSP
-- https://github.com/sumneko/lua-language-server
-- https://github.com/sumneko/lua-language-server/blob/master/locale/en-us/setting.lua
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#sumneko_lua
return {
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file('', true),
      },
      diagnostics = {
        globals = { 'vim' },
        disable = { 'lowercase-global' },
      },
      completion = {
        callSnippet = 'Replace',
        keywordSnippet = 'Replace',
      },
      telemetry = {
        enable = false,
      },
    },
  },
}
