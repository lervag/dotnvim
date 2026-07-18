local M = {}

---Determine whether a line lies inside a fenced code block using treesitter
---@param lnum integer
---@param col integer
---@return boolean
local function is_code(lnum, col)
  local captures = vim.treesitter.get_captures_at_pos(0, lnum - 1, col)
  return captures[1] ~= nil and captures[1].capture == "markup.raw.block"
end

---Fold levels for markdown files
---@param lnum integer
---@return string
M.foldexpr = function(lnum)
  local line = vim.fn.getline(lnum) --[[@as string]]

  if is_code(lnum, #line) then
    if line:match "^%s*```" then
      return is_code(lnum + 1, 0) and "a1" or "s1"
    end

    return "="
  end

  local match = vim.fn.match(line, [[^#\{1,6}\s*[^#].*]])
  if match >= 0 then
    return ">" .. #line:match "#*"
  end

  return "="
end

return M
