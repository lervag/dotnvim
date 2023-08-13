local group = vim.api.nvim_create_augroup("init", {})

vim.api.nvim_create_autocmd({ "VimEnter", "BufReadPost" }, {
  desc = "Go to last known position on buffer open",
  group = group,
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local buf_lines = vim.api.nvim_buf_line_count(0)

    if mark[1] > 0 and mark[1] <= buf_lines then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end

    if vim.o.foldlevel == 0 then
      vim.cmd [[normal! zM]]
    end

    vim.cmd [[normal! zvzz]]
  end,
})
vim.api.nvim_create_autocmd("CmdWinEnter", {
  desc = "Set CmdLineWin mappings/options",
  group = group,
  callback = function()
    vim.keymap.set("n", "q", "<c-c><c-c>", { buffer = true })
    vim.keymap.set("n", "<c-f>", "<c-c>", { buffer = true })
  end,
})
vim.api.nvim_create_autocmd({ "WinEnter", "FocusGained" }, {
  desc = "Toggle cursorline on enter",
  group = group,
  callback = function()
    if vim.o.buflisted then
      vim.wo.cursorline = true
    end
  end,
})
vim.api.nvim_create_autocmd({ "WinLeave", "FocusLost" }, {
  desc = "Toggle cursorline on leave",
  group = group,
  callback = function()
    vim.wo.cursorline = false
  end,
})

-- See also: after/plugin/init_autocmds.vim
