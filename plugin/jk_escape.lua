local reltime = vim.fn.reltime
local reltimefloat = vim.fn.reltimefloat

---@return string
local function escape()
  ---@diagnostic disable-next-line
  local timediff = reltimefloat(reltime(vim.w.__esc_time_j or { 0, 0 }))
  vim.w.__esc_time_j = { 0, 0 }

  if timediff <= 0.25 then
    return "<bs><esc>"
  end

  return "k"
end

vim.keymap.set("i", "k", escape, {
  desc = "jk escape",
  expr = true,
})

local group = vim.api.nvim_create_augroup("init_escape", {})
vim.api.nvim_create_autocmd("InsertCharPre", {
  group = group,
  callback = function()
    ---@diagnostic disable-next-line
    vim.w.__esc_time_j = vim.v.char == "j" and reltime() or { 0, 0 }
  end,
})
