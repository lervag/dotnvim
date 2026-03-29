vim.g.tmux_navigator_no_mappings = 1
vim.g.tmux_navigator_disable_when_zoomed = 1
vim.g.VimuxOrientation = "h"
vim.g.VimuxHeight = "50"
vim.g.VimuxResetSequence = ""

vim.pack.add {
  "https://github.com/christoomey/vim-tmux-navigator",
  "https://github.com/benmills/vimux",
}

vim.keymap.set("n", "<c-h>", "<cmd>TmuxNavigateLeft<cr>")
vim.keymap.set("n", "<c-j>", "<cmd>TmuxNavigateDown<cr>")
vim.keymap.set("n", "<c-k>", "<cmd>TmuxNavigateUp<cr>")
vim.keymap.set("n", "<c-l>", "<cmd>TmuxNavigateRight<cr>")
vim.keymap.set("n", "<leader>io", "<cmd>call VimuxOpenRunner()<cr>")
vim.keymap.set("n", "<leader>iq", "<cmd>VimuxCloseRunner<cr>")
vim.keymap.set("n", "<leader>ip", "<cmd>VimuxPromptCommand<cr>")
vim.keymap.set("n", "<leader>in", "<cmd>VimuxInspectRunner<cr>")
vim.keymap.set("n", "<leader>ii", "<cmd>VimuxRunCommand 'jkk'<cr>")
vim.keymap.set(
  "n",
  "<leader>is",
  "<cmd>set opfunc=personal#vimux#operator<cr>g@"
)
vim.keymap.set(
  "n",
  "<leader>iss",
  "<cmd>call VimuxRunCommand(getline('.'))<cr>"
)
vim.keymap.set("x", "<leader>is", [["vy :call VimuxSendText(@v)<cr>]])
