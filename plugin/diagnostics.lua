vim.diagnostic.config {
  virtual_text = {
    severity = { min = vim.diagnostic.severity.WARN },
    source = true,
    -- source = "if_many",
  },
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
    priority = 300,
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
}

local diagnostics_active = true
local function toggle_diagnostics()
  diagnostics_active = not diagnostics_active
  if diagnostics_active then
    vim.diagnostic.enable()
    vim.diagnostic.show()
    vim.notify("Diagnostics enabled.", vim.log.levels.INFO)
  else
    vim.diagnostic.hide()
    vim.diagnostic.enable(false)
    vim.notify("Diagnostics disabled!", vim.log.levels.INFO)
  end
end

vim.keymap.set("n", "<leader>qQ", toggle_diagnostics)
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
