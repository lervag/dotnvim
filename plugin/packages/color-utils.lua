vim.pack.add {
  "https://github.com/chrisbra/Colorizer",
  "https://github.com/uga-rosa/ccc.nvim",
}

local my_border = require("lervag.const").border
local ccc = require "ccc"
ccc.setup {
  point_char = "❚",
  empty_point_bg = false,
  inputs = {
    ccc.input.rgb,
    ccc.input.hsv,
    ccc.input.hsl,
    ccc.input.cmyk,
  },
  win_opts = {
    border = my_border,
  },
}

vim.keymap.set("n", "<f4>", "<cmd>CccPick<cr>", { desc = "ccc.nvim" })
vim.keymap.set(
  "n",
  "<s-f4>",
  "<cmd>CccHighlighterToggle<cr>",
  { desc = "ccc.nvim" }
)
vim.keymap.set(
  "n",
  "<f16>",
  "<cmd>CccHighlighterToggle<cr>",
  { desc = "ccc.nvim" }
)

vim.api.nvim_create_autocmd("BufRead", {
  group = vim.api.nvim_create_augroup("init_ccc", {}),
  pattern = "solarized_custom.lua",
  desc = "Activate CccHighlighter for colorscheme file",
  command = "CccHighlighterEnable",
})
