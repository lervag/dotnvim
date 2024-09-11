local ui = require "lervag.statusline.ui"

---@param n integer
---@return string
local function get_tablabel(n)
  local buflist = vim.fn.tabpagebuflist(n)
  local winnr = vim.fn.tabpagewinnr(n)
  local bufnr = buflist[winnr]

  local name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":t")
  if #name > 0 then
    return " " .. name .. " "
  end

  local ok, type =
    pcall(vim.api.nvim_get_option_value, "buftype", { buf = bufnr })
  if ok and #type > 0 then
    return " [" .. type .. "] "
  end

  return " [No Name] "
end

local M = {}

function M.main()
  local active_tabnr = vim.fn.tabpagenr()
  local tabs = vim.fn.tabpagenr "$"

  local tl = ""

  for i = 1, tabs do
    local label = get_tablabel(i)

    if i == active_tabnr then
      tl = tl .. ui.colorize("", "TabLineSelSep")
      .. ui.colorize(label, "TabLineSel")
      .. ui.colorize("", "TabLineSelSep")
    else
      tl = tl .. " " .. label .. " "
    end
  end

  return "    " .. tl
end

return M
