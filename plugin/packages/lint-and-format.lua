vim.pack.add {
  "https://github.com/stevearc/conform.nvim",
  "https://github.com/mfussenegger/nvim-lint",
  "https://github.com/chrisgrieser/nvim-rulebook",
}

require("conform").setup {
  formatters = {
    kulala = {
      command = "kulala-fmt",
      args = { "format", "$FILENAME" },
      stdin = false,
    },
  },
  formatters_by_ft = {
    graphql = { "prettierd" },
    groovy = { "npm-groovy-lint" },
    http = { "kulala" },
    javascript = { "prettierd" },
    javascriptreact = { "prettierd" },
    json = { "prettierd" },
    kotlin = { "ktlint" },
    lua = { "stylua" },
    markdown = { "prettierd", "markdownlint", "markdown-toc" },
    sql = { "pg_format" },
    typescript = { "prettierd" },
    typescriptreact = { "prettierd" },
  },
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

vim.keymap.set("n", "<leader>lf", function()
  require("conform").format {
    async = true,
    lsp_format = "fallback",
  }
end, { desc = "Format buffer" })
vim.keymap.set("n", "<leader>qri", function()
  require("rulebook").ignoreRule()
end)
vim.keymap.set("n", "<leader>qrl", function()
  require("rulebook").lookupRule()
end)
vim.keymap.set({ "n", "x" }, "<leader>lF", function()
  require("rulebook").suppressFormatter()
end)
