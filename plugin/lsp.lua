-- This sets up the internal language server interface
-- See also: plugins/nvim-lspconfig.lua

local lsp = vim.lsp

-- utility functions: override/extend builtin handlers
local function preview_location_handler(_, result)
  if result == nil or vim.tbl_isempty(result) then
    return nil
  end
  lsp.util.preview_location(result[1], { border = 'rounded' })
end

function PeekDefinition()
  local params = lsp.util.make_position_params()
  return lsp.buf_request(0, 'textDocument/definition', params, preview_location_handler)
end

lsp.handlers['textDocument/hover'] = lsp.with(
  lsp.handlers.hover, { border = 'rounded' })
lsp.handlers['textDocument/signatureHelp'] = lsp.with(
  lsp.handlers.hover, { border = 'rounded' })

-- TODO: Only lint _after_ insert mode, not while typing!


local opts = { noremap=true, silent=true }
vim.api.nvim_set_keymap('n', '<leader>ld', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
vim.api.nvim_set_keymap('n', '<leader>lD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
vim.api.nvim_set_keymap('n', '<leader>li', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
vim.api.nvim_set_keymap('n', '<leader>lk', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
vim.api.nvim_set_keymap('n', '<leader>lr', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
vim.api.nvim_set_keymap('n', '<leader>lp', '<cmd>lua vim.diagnostic.goto_prev()<cr>', opts)
vim.api.nvim_set_keymap('n', '<leader>ln', '<cmd>lua vim.diagnostic.goto_next()<cr>', opts)
vim.api.nvim_set_keymap('n', '<leader>ll', '<cmd>lua vim.diagnostic.setloclist()<cr>', opts)
-- vim.api.nvim_set_keymap('n', '<leader><space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
-- vim.api.nvim_set_keymap('n', '<leader><space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
-- vim.api.nvim_set_keymap('n', '<leader><space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
-- vim.api.nvim_set_keymap('n', '<leader><space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
-- vim.api.nvim_set_keymap('n', '<leader><space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
-- vim.api.nvim_set_keymap('n', '<leader>gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
-- vim.api.nvim_set_keymap('n', '<leader><space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
-- vim.api.nvim_set_keymap('n', '<leader><space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

--[[ Mappings
   <leader>lr   show-references
   <leader>li   lint-info
   <leader>ll   lint-info-window
   K            show-doc
--]]
