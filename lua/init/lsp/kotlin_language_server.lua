-- Kotlin Language Server
-- https://github.com/fwcd/kotlin-language-server
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#kotlin_language_server
return {
  handlers = {
    ["textDocument/publishDiagnostics"] = function() end
  }
}
