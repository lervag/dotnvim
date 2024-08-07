local M = {}

function M.refresh()
  ---@type integer
  M.active_winid = vim.g.statusline_winid
  M.active_bufnr = vim.api.nvim_win_get_buf(M.active_winid)
  M.active_name = vim.api.nvim_buf_get_name(M.active_bufnr)
  M.is_active = M.active_winid == vim.api.nvim_get_current_win()
end

return M
