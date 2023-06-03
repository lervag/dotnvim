vim.bo.define = [[^\s*\(def\|class\)]]
vim.bo.includeexpr = "personal#python#includexpr()"

vim.wo.colorcolumn = "+1"
vim.wo.foldexpr = "personal#python#foldexpr(v:lnum)"
vim.wo.foldmethod = "expr"

vim.fn["personal#python#set_path"]()

-- Use custom dap command
vim.keymap.set("n", "<leader>dd", function()
  local dap = require "dap"
  if dap.status() == "" then
    vim.fn.feedkeys(":Debugpy ", "nt")
  else
    dap.continue()
  end
end)
