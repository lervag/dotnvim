-- See also ftplugin/calendar.vim
vim.g.calendar_first_day = "monday"
vim.g.calendar_date_endian = "big"
vim.g.calendar_frame = "space"
vim.g.calendar_week_number = 1

vim.keymap.set(
  "n",
  "<leader>c",
  "<cmd>Calendar -position=here<cr>",
  { desc = "calendar.vim" }
)

vim.pack.add { "https://github.com/itchyny/calendar.vim" }
