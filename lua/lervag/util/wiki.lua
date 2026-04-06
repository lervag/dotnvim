local M = {}

---Fold levels for wiki files
---@param lnum integer
---@return string
M.foldexpr = function(lnum)
  local line = vim.fn.getline(lnum)

  if vim.fn["wiki#u#is_code"](lnum) == 1 then
    if line:match "^%s*```" then
      return vim.fn["wiki#u#is_code"](lnum + 1) == 1 and "a1" or "s1"
    end

    return "="
  end

  local match = vim.fn.match(line, vim.g["wiki#rx#header_md_atx"])
  if match >= 0 then
    return ">" .. #line:match "#*"
  end

  return "="
end

return M
