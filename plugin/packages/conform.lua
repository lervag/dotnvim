vim.pack.add { "https://github.com/stevearc/conform.nvim" }

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
    mdx = { "prettierd", "markdownlint", "markdown-toc" },
    sql = { "pg_format" },
    typescript = { "prettierd" },
    typescriptreact = { "prettierd" },
  },
}

vim.keymap.set("n", "<leader>lf", function()
  require("conform").format {
    async = true,
    lsp_format = "fallback",
  }
end, { desc = "Format buffer" })
