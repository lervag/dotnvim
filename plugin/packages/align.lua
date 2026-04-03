vim.pack.add { "https://github.com/junegunn/vim-easy-align" }

vim.g.easy_align_bypass_fold = 1

---@param vmode boolean
---@return nil
local function align(vmode)
  if not vim.o.modifiable then
    return
  end

  local l1, l2
  if vmode then
    l1 = vim.fn.line "."
    l2 = vim.fn.line "v"
    if l1 > l2 then
      l2, l1 = l1, l2
    end
  else
    l1 = vim.fn.line "'["
    l2 = vim.fn.line "']"
  end

  local sel_save = vim.o.selection
  vim.o.selection = "inclusive"

  pcall(function()
    local cmd = vim.g.easy_align_need_repeat and vim.g.easy_align_last_command
      or "call easy_align#align(0, 1, '', '')"
    vim.cmd(string.format("%d,%d %s", l1, l2, cmd))
    vim.fn["repeat#set"] "\\<plug>(align-repeat)"
  end)

  vim.o.selection = sel_save
end

---Global align operator function
---@return nil
function align_operator()
  align(false)
end

vim.keymap.set("n", "ga", function()
  vim.go.operatorfunc = "v:lua.align_operator"
  return "g@"
end, { expr = true })

vim.keymap.set("x", "ga", function()
  align(true)
end)

vim.keymap.set("n", "<plug>(align-repeat)", function()
  pcall(function()
    vim.g.easy_align_need_repeat = 1
    vim.cmd [[normal! .]]
  end)
  vim.g.easy_align_need_repeat = nil
end, { silent = true })
