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

return M
