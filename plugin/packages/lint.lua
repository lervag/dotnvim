vim.pack.add {
  "https://github.com/mfussenegger/nvim-lint",
  "https://github.com/chrisgrieser/nvim-rulebook",
}

local lint = require "lint"
lint.linters_by_ft = {
  typescript = { "eslint_d" },
  javascript = { "eslint_d" },
  javascriptreact = { "eslint_d" },
  graphql = { "eslint_d" },
}

vim.api.nvim_create_autocmd("BufWritePost", {
  callback = function()
    lint.try_lint()
  end,
})

vim.keymap.set("n", "<leader>qri", function()
  require("rulebook").ignoreRule()
end)
vim.keymap.set("n", "<leader>qrl", function()
  require("rulebook").lookupRule()
end)
vim.keymap.set({ "n", "x" }, "<leader>lF", function()
  require("rulebook").suppressFormatter()
end)
