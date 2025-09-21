local parts = require "lervag.statusline.parts"
local ctx = require "lervag.statusline.context"
local ui = require "lervag.statusline.ui"

local schemes = {}

---@return string
function schemes.fugitive()
  ---@type string | nil
  local commit = ctx.active_name:match "/%.git//(%x+)"
  if not commit then
    return ui.green_light " fugitive: " .. ui.gold "Git status"
  end

  ---@type string | nil
  local path = ctx.active_name:match "/%.git//%x+/(.*)"
  if not path then
    return table.concat {
      ui.green_light " fugitive: %<",
      ui.gold(commit),
      parts.common(),
    }
  end

  return parts.gitfile(#commit > 1 and commit or "HEAD", path)
end

---@return string
function schemes.diffview()
  ---@type string | nil
  local commit = ctx.active_name:match "/%.git/([%x:]+)"
  if not commit then
    local name = ctx.active_name:match "panels/%d+/(.*)" or "???"
    return " " .. ui.gold(name)
  end
  commit = commit:sub(1, 8)

  local path = ctx.active_name:match "/%.git/[%x:]+/(.*)"
  return path and parts.gitfile(commit, path) or ""
end


local M = {}

---@return string | nil
function M.parse()
  local matched = ctx.active_name:match "^(%w+)://"
  if matched and schemes[matched] then
    return schemes[matched]()
  end
end

return M
