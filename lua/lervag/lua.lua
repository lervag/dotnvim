---@class LuaUtils
---Lua utility functions
---
---Notice that if I rename this module filename, then I will also need to
---update lua/lervag/init/autocommands.lua near line 55.
local M = {}

---@return string foldtext
function M.foldtext_packages()
  local lines = vim.api.nvim_buf_get_lines(
    0,
    vim.v.foldstart - 1,
    vim.v.foldstart + 1,
    true
  )
  if vim.v.foldlevel == 2 then
    local line = (lines[2] or "")
      :gsub([[url = "git@github%.com:]], '"')
      :gsub([[^%s*"]], "  ")
      :gsub([[",$]], "")
    return line
  end

  return lines[1] or ""
end

return M
