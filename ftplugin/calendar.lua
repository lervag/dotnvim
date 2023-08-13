for lhs, rhs in pairs {
  ["<c-e>"] = "<c-^>",
  ["<c-u>"] = "<cmd>WinBufDelete<cr>",
  ["<cr>"] = function()
    local year, month, day =
      unpack(vim.api.nvim_eval "b:calendar.day().get_ymd()")
    ---@diagnostic disable-next-line: redundant-parameter
    local date = vim.fn.printf("%d-%0.2d-%0.2d", year, month, day)
    vim.fn["wiki#journal#open"](date)
  end,
} do
  vim.keymap.set("n", lhs, rhs, { buffer = true })
end
