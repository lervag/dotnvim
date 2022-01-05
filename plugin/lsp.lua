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


--[[ Mappings
   <leader>ld   go-to-definition
   <leader>lr   show-references
   <leader>lp   lint-prev
   <leader>ln   lint-next
   <leader>li   lint-info
   <leader>ll   lint-info-window
   K            show-doc
--]]
