-- https://github.com/georgewfraser/java-language-server
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#java_language_server
return {
  cmd = { "java-language-server" },
  handlers = {
    ["textDocument/publishDiagnostics"] = function() end
  }
}
