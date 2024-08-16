local parts = require "lervag.statusline.parts"
local ctx = require "lervag.statusline.context"
local ui = require "lervag.statusline.ui"

local M = {}

---@return string | nil
function M.preview()
  local ok, previewwindow = pcall(
    vim.api.nvim_get_option_value,
    "previewwindow",
    { win = ctx.active_winid }
  )
  if ok and previewwindow then
    return table.concat {
      parts.filename(),
      parts.common(),
      "%=",
      ui.alert " [preview] ",
    }
  end
end

---@return string
function M.normal()
  return table.concat {
    parts.filename(),
    parts.common(),
    "%=",
    parts.dap(),
    parts.git(),
    " ",
  }
end

return M
