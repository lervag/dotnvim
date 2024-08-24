local context = require "lervag.statusline.context"
local stl_schemes = require "lervag.statusline.stl_schemes"
local stl_buftypes = require "lervag.statusline.stl_buftypes"
local stl_filetypes = require "lervag.statusline.stl_filetypes"
local tal_core = require "lervag.statusline.tal_core"
local parts = require "lervag.statusline.parts"
local ctx = require "lervag.statusline.context"
local ui = require "lervag.statusline.ui"

---@return string | nil
local function stl_preview()
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
      ui.red " [preview] ",
    }
  end
end

---@return string
local function stl_normal()
  return table.concat {
    parts.filename(),
    parts.common(),
    "%=",
    parts.dap(),
    parts.lsp(),
    parts.git(),
    " ",
  }
end

local M = {}

---This is the entry point for the statusline function.
---It returns a string that adheres to the docs in :help 'statusline'.
---@return string
function M.statusline()
  context.refresh()

  local stl_scheme = stl_schemes.parse()
  if stl_scheme then
    return stl_scheme
  end

  local stl_bt = stl_buftypes.parse()
  if stl_bt then
    return stl_bt
  end

  local stl_ft = stl_filetypes.parse()
  if stl_ft then
    return stl_ft
  end

  local stl_p = stl_preview()
  if stl_p then
    return stl_p
  end

  return stl_normal()
end

---@return string
function M.tabline()
  return tal_core.main()
end

vim.api.nvim_create_user_command("ReloadStatusline", function()
  for name, _ in pairs(package.loaded) do
    if name:match "^lervag.statusline" then
      package.loaded[name] = nil
    end
  end

  dofile(debug.getinfo(1, "S").source:sub(2))
end, {})

return M
