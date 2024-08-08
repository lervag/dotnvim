local ctx = require "lervag.statusline.context"

local M = {}

function M.info(text)
  return ctx.is_active and "%#SLInfo#" .. text .. "%*" or text
end

function M.alert(text)
  return ctx.is_active and "%#SLAlert#" .. text .. "%*" or text
end

function M.success(text)
  return ctx.is_active and "%#SLSuccess#" .. text .. "%*" or text
end

function M.highlight(text)
  return ctx.is_active and "%#SLHighlight#" .. text .. "%*" or text
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
