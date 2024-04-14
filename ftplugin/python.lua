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

vim.keymap.set("n", "<leader>lo", function()
  local params = {
    command = "pyright.organizeimports",
    arguments = { vim.uri_from_bufnr(0) },
  }

  local clients = vim.lsp.get_clients {
    bufnr = vim.api.nvim_get_current_buf(),
    name = "pyright",
  }
  for _, client in ipairs(clients) do
    client.request("workspace/executeCommand", params, nil, 0)
  end
end)
