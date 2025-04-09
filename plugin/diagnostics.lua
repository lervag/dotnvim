local __is_active = true
local function toggle_show_diagnostics()
  if __is_active then
    vim.diagnostic.hide()
  else
    vim.diagnostic.show()
  end
  __is_active = not __is_active
end

vim.keymap.set("n", "<leader>qQ", toggle_show_diagnostics)
vim.keymap.set("n", "<leader>qL", vim.diagnostic.setloclist)
vim.keymap.set("n", "<leader>ql", vim.diagnostic.setqflist)
vim.keymap.set("n", "<leader>qc", "<cmd>cclose<cr>")
vim.keymap.set("n", "<leader>qC", "<cmd>lclose<cr>")

vim.api.nvim_create_autocmd("InsertEnter", {
  callback = function()
    pcall(vim.diagnostic.hide)
  end,
})

vim.api.nvim_create_autocmd("ModeChanged", {
  pattern = "i:*",
  callback = function()
    pcall(vim.diagnostic.show)
  end,
})

vim.diagnostic.config {
  update_in_insert = false,
  severity_sort = true,
  float = {
    focusable = false,
    style = "minimal",
    ---@diagnostic disable-next-line: assign-type-mismatch
    border = require("lervag.const").border,
    source = "if_many",
    header = "",
    prefix = "",
  },
  signs = {
    priority = 190,
    text = {
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.WARN] = "",
      [vim.diagnostic.severity.INFO] = "",
      [vim.diagnostic.severity.HINT] = "",
    },
    numhl = {
      [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
      [vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
      [vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
      [vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
    },
  },
  virtual_lines = { current_line = true },
  virtual_text = {
    severity = { min = vim.diagnostic.severity.ERROR },
    format = function(diagnostic)
      local msg = diagnostic.message:lower():gsub("%.%s*$", "")
      return msg
    end,
  },
}
