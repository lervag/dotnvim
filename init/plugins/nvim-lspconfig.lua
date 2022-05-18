local lc = require 'lspconfig'
local lsp_status = require 'lsp-status'
lsp_status.register_progress()

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = vim.tbl_extend('keep', capabilities, lsp_status.capabilities)
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)


-- Use separate files for each desired LSP placed in
-- ~/.config/nvim/lua/init/lsp/
local servers = vim.tbl_map(
  function(x)
    return x:match("([^/]*).lua$")
  end,
  vim.api.nvim_get_runtime_file("lua/init/lsp/*.lua", true)
)

for _, server in pairs(servers) do
  local _, user_opts = pcall(require, "init.lsp." .. server)
  local opts = vim.tbl_deep_extend('force', {
    capabilities = capabilities,
    flags = {
      debounce_text_changes = 150
    }
  }, user_opts)
  lc[server].setup(opts)
end
