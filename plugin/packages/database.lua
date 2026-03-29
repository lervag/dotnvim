vim.g.db_ui_use_nerd_fonts = 1

vim.pack.add {
  "https://github.com/kristijanhusak/vim-dadbod-completion",
  "https://github.com/kristijanhusak/vim-dadbod-ui",
  "https://github.com/tpope/vim-dadbod",
  "https://github.com/xemptuous/sqlua.nvim",
}

require("sqlua").setup()
