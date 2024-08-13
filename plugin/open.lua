local open = vim.ui.open

---@param path string Path or URL to open
---@return vim.SystemObj|nil # Command object, or nil if not found.
---@return nil|string # Error message on failure, or nil on success.
local function open_adjusted(path)
  if path:match "^[%w-_.]+/[%w-_.]+$" then
    path = "https://github.com/" .. path
  end

  return open(path)
end

vim.ui.open = open_adjusted
