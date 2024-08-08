local context = require "lervag.statusline.context"
local stl_schemes = require "lervag.statusline.stl_schemes"
local stl_buftypes = require "lervag.statusline.stl_buftypes"
local stl_filetypes = require "lervag.statusline.stl_filetypes"
local stl_core = require "lervag.statusline.stl_core"
local tal_core = require "lervag.statusline.tal_core"

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

  local stl_p = stl_core.preview()
  if stl_p then
    return stl_p
  end

  return stl_core.normal()
end

---@return string
function M.tabline()
  return tal_core.main()
end

return M
