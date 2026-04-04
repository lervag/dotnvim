vim.diagnostic.config {
  update_in_insert = false,
  severity_sort = true,
  float = {
    focusable = false,
    style = "minimal",
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
}

vim.pack.add { "https://github.com/rachartier/tiny-inline-diagnostic.nvim" }

require("tiny-inline-diagnostic").setup {
  options = {
    -- multilines = { enabled = true },
    show_sources = { enabled = true },
  },
}

vim.keymap.set("n", "<leader>qq", function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end)
vim.keymap.set("n", "<leader>qL", vim.diagnostic.setloclist)
vim.keymap.set("n", "<leader>ql", vim.diagnostic.setqflist)
vim.keymap.set("n", "<leader>qc", "<cmd>cclose<cr>")
vim.keymap.set("n", "<leader>qC", "<cmd>lclose<cr>")
vim.keymap.set("n", "<leader>qy", function()
  local diagnostics = vim.diagnostic.get(0, {
    lnum = vim.api.nvim_win_get_cursor(0)[1] - 1,
  })
  local count = #diagnostics
  if count == 0 then
    return
  end

  ---@diagnostic disable-next-line: param-type-mismatch
  local messages = vim.iter(diagnostics):map(function(d)
    return d.message
  end)

  local text = count == 1 and messages:totable()[1]
    or messages
      :enumerate()
      :map(function(_, msg)
        return ("- %s"):format(msg)
      end)
      :join "\n"

  vim.fn.setreg("+", text)
  vim.notify(
    ("Copied %d diagnostic%s to clipboard"):format(
      count,
      count == 1 and "" or "s"
    )
  )
end)
