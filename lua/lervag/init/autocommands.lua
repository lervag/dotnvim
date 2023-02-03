group = vim.api.nvim_create_augroup("init", { clear = true })

vim.api.nvim_create_autocmd("BufReadPost", {
  group = group,
  pattern = "*",
  desc = "Go to last known position on buffer open",
  command = [[ call personal#init#go_to_last_known_position() ]]
})
vim.api.nvim_create_autocmd("CmdWinEnter", {
  group = group,
  pattern = "*",
  desc = "Set CmdLineWin mappings/options",
  command = [[ call personal#init#command_line_win() ]]
})
vim.api.nvim_create_autocmd({"WinEnter", "FocusGained"}, {
  group = group,
  pattern = "*",
  desc = "Toggle cursorline on enter",
  command = [[ call personal#init#toggle_cursorline(1) ]]
})
vim.api.nvim_create_autocmd({"WinLeave", "FocusLost"}, {
  group = group,
  pattern = "*",
  desc = "Toggle cursorline on leave",
  command = [[ call personal#init#toggle_cursorline(0) ]]
})

-- Statusline
vim.api.nvim_create_autocmd({
  "VimEnter", "WinEnter", "BufWinEnter", "FileType", "VimResized",
  "BufHidden", "BufWinLeave", "BufUnload"
}, {
  group = group,
  pattern = "*",
  desc = "Refresh statusline",
  command = [[ call personal#statusline#refresh() ]]
})

-- See also: after/plugin/init_autocmds.vim
