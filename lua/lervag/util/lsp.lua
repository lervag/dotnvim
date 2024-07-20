local const = require "lervag.const"

local M = {}

---@param _ lsp.ResponseError?
---@param result lsp.Hover
---@param ctx lsp.HandlerContext
function M.hover(_, result, ctx)
  local config = { border = const.border, title = " hover " }
  config.focus_id = ctx.method
  if vim.api.nvim_get_current_buf() ~= ctx.bufnr then
    -- Ignore result since buffer changed. This happens for slow language servers.
    return
  end
  if not (result and result.contents) then
    return
  end
  local format = "markdown"
  local contents ---@type string[]
  if
    type(result.contents) == "table" and result.contents.kind == "plaintext"
  then
    format = "plaintext"
    contents =
      vim.split(result.contents.value or "", "\n", { trimempty = true })
  else
    contents = vim.lsp.util.convert_input_to_markdown_lines(result.contents)
    for i, s in ipairs(contents) do
      contents[i] = s:gsub("\\([#.-])", "%1")
    end
  end
  if vim.tbl_isempty(contents) then
    return
  end
  return vim.lsp.util.open_floating_preview(contents, format, config)
end

M.signatureHelp = vim.lsp.with(
  vim.lsp.handlers.signature_help,
  { border = const.border, title = "signature" }
)

return M
