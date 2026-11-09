vim.g.tmux_navigator_no_mappings = 1
vim.g.tmux_navigator_disable_when_zoomed = 1
vim.g.VimuxOrientation = "h"
vim.g.VimuxHeight = "50"
vim.g.VimuxResetSequence = ""

vim.pack.add {
  "https://github.com/christoomey/vim-tmux-navigator",
  "https://github.com/samharju/yeet.nvim",
}

require("yeet").setup {}

vim.keymap.set("n", "<c-h>", "<cmd>TmuxNavigateLeft<cr>")
vim.keymap.set("n", "<c-j>", "<cmd>TmuxNavigateDown<cr>")
vim.keymap.set("n", "<c-k>", "<cmd>TmuxNavigateUp<cr>")
vim.keymap.set("n", "<c-l>", "<cmd>TmuxNavigateRight<cr>")

vim.keymap.set("v", "<leader>is", function()
  require("yeet").execute_selection {
    yeet_and_run = true,
    clear_before_yeet = false,
  }
end)
vim.keymap.set("n", "<leader>is", function()
  require("yeet").execute(vim.api.nvim_get_current_line(), {
    yeet_and_run = true,
    clear_before_yeet = false,
  })
end)
vim.keymap.set("n", "<leader>ii", require("yeet").execute)
vim.keymap.set("n", "<leader>io", require("yeet").list_cmd)
vim.keymap.set("n", "<leader>iq", function()
  require("yeet").setqflist { open = true }
end)
