local lc = require 'lspconfig'
-- local lsp_status = require 'lsp-status'
-- lsp_status.register_progress()

local capabilities = require('cmp_nvim_lsp').default_capabilities()
-- capabilities = vim.tbl_extend('keep', capabilities, lsp_status.capabilities)


-- Use separate files for each desired LSP placed in
-- ~/.config/nvim/lua/lervag/lsp/
local servers = vim.tbl_map(
  function(x)
    return x:match("([^/]*).lua$")
  end,
  vim.api.nvim_get_runtime_file("lua/init/lsp/*.lua", true)
)

for _, server in pairs(servers) do
  local _, user_opts = pcall(require, "lervag.lsp." .. server)
  local opts = vim.tbl_deep_extend('force', {
    capabilities = capabilities,
    flags = {
      debounce_text_changes = 150
    }
  }, user_opts)
  lc[server].setup(opts)
end

local au_group = vim.api.nvim_create_augroup("init_lsp", { clear = true })
vim.api.nvim_create_autocmd("LspAttach", {
  desc = "Disable semantic token highlighting engine",
  group = au_group,
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    client.server_capabilities.semanticTokensProvider = nil
  end,
})
