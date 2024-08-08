local ui = require "lervag.statusline.ui"

---@param n integer
---@return string
local function get_tablabel(n)
  local buflist = vim.fn.tabpagebuflist(n)
  local winnr = vim.fn.tabpagewinnr(n)
  local bufnr = buflist[winnr]

  local name = vim.api.nvim_buf_get_name(bufnr)
  if #name > 0 then
    return " " .. vim.fn.fnamemodify(name, ":t") .. " "
  end

  local ok, type = pcall(vim.api.nvim_get_option_value, "buftype", { buf = bufnr })
  if ok and #type > 0 then
    return " [" .. type .. "] "
  end

  return " [No Name] "
end


local M = {}

function M.main()
  local active_tabnr = vim.fn.tabpagenr()
  local tabs = vim.fn.tabpagenr("$")

  local tl = ""

  for i = 1, tabs do
    tl = tl .. ui.color_if(get_tablabel(i), "TabLineSel", i == active_tabnr)
  end

  return tl
end

return M
