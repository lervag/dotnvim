local ctx = require "lervag.statusline.context"
local ui = require "lervag.statusline.ui"

local buftypes = {}

function buftypes.help()
  local name = vim.fn.fnamemodify(ctx.active_name, ":t:r")
  return ui.colorize_active(" vimdoc: ", "green_light")
    .. ui.colorize_active(name, "gold")
end

function buftypes.nofile()
  return ui.colorize_active(" %f" .. "%= %l/%L ", "green_light")
end

function buftypes.prompt()
  return ui.colorize_active(" %f" .. "%= %l/%L ", "green_light")
end

function buftypes.quickfix()
  local winnr = vim.api.nvim_win_get_number(ctx.active_winid)

  local qf_nr_stl = ""
  local qf_last = vim.fn["personal#qf#get_prop"]("nr", "$", winnr)
  if qf_last > 1 then
    local qf_nr = vim.fn["personal#qf#get_prop"]("nr", 0, winnr)
    qf_nr_stl = " " .. qf_nr .. "/" .. qf_last
  end

  return ui.colorize_active(
    table.concat {
      " [",
      vim.fn["personal#qf#is_loc"](winnr) and "Loclist" or "Quickfix",
      qf_nr_stl,
      "]",
      " (",
      vim.fn["personal#qf#length"](winnr),
      ") ",
      vim.fn["personal#qf#get_prop"]("title", 0, winnr),
    },
    "gold"
  )
end

local M = {}

---@return string | nil
function M.parse()
  local ok, bt =
    pcall(vim.api.nvim_get_option_value, "buftype", { buf = ctx.active_bufnr })
  if ok and buftypes[bt] then
    return buftypes[bt]()
  end
end

return M
