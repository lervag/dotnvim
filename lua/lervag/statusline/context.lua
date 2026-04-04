---@class SLContext
---@field active_winid integer
---@field active_bufnr integer
---@field active_name string
---@field is_active boolean
local M = {}

function M.refresh()
  ---@type integer
  M.active_winid = vim.g.statusline_winid

  ---@type integer
  M.active_bufnr = vim.api.nvim_win_get_buf(M.active_winid)

  ---@type string
  M.active_name = vim.api.nvim_buf_get_name(M.active_bufnr)

  ---@type boolean
  M.is_active = M.active_winid == vim.api.nvim_get_current_win()
end

return M
