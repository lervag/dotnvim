vim.pack.add { "https://github.com/stevearc/quicker.nvim" }

require("quicker").setup {
  type_icons = {
    E = " ",
    W = " ",
    I = " ",
    N = " ",
    H = " ",
  },
  borders = {
    vert = " ",
    strong_header = "━",
    strong_cross = " ",
    strong_end = " ",
    soft_header = "╌",
    soft_cross = " ",
    soft_end = " ",
  },
}

vim.keymap.set("n", "<leader>qo", function()
  require("quicker").toggle { focus = true }
end, {
  desc = "Toggle quickfix list",
})
vim.keymap.set("n", "<leader>ql", function()
  require("quicker").toggle { loclist = true }
end, {
  desc = "Toggle loclist window",
})
