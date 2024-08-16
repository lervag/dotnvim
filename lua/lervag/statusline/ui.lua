local ctx = require "lervag.statusline.context"

local M = {}

function M.info(text)
  return M.color_active(text, "SLInfo")
end

function M.alert(text)
  return M.color_active(text, "SLAlert")
end

function M.success(text)
  return M.color_active(text, "SLSuccess")
end

function M.highlight(text)
  return M.color_active(text, "SLHighlight")
end

function M.cyan(text)
  return M.color_active(text, "SLCyan")
end

---@param text string
---@param group string
---@return string
function M.color_active(text, group)
  if ctx.is_active then
    return "%#" .. group .. "#" .. text .. "%*"
  end

  return text
end

---@param text string
---@param group string
---@param condition boolean
---@return string
function M.color_if(text, group, condition)
  if condition then
    return "%#" .. group .. "#" .. text .. "%*"
  end

  return text
end

return M
