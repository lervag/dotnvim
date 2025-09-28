local M = {}

---Load and return snippets from specified filetype
---
---@param filetype string
---@return table
M.require = function(filetype)
  ---@type string
  local vimrc = vim.env.MYVIMRC
  local root = vim.fs.dirname(vimrc)
  local path = string.format("%s/snippets/%s.lua", root, filetype)

  local ok, contents = pcall(dofile, path)
  if ok and type(contents) == "table" then
    return contents
  end

  return {}
end

return M
