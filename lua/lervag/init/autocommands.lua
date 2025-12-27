local group = vim.api.nvim_create_augroup("init", {})

vim.api.nvim_create_autocmd({ "VimEnter", "FileType" }, {
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

---@diagnostic disable-next-line: param-type-mismatch
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

vim.api.nvim_create_autocmd("FileType", {
  desc = "Ensure &foldtext is kept empty regardless of filetype",
  group = group,
  callback = function()
    if not vim.wo.foldtext:match("lervag.lua") then
      vim.wo.foldtext = ""
    end
  end,
})

vim.api.nvim_create_autocmd("User", {
  pattern = "DapProgressUpdate",
  command = "redrawstatus",
})

-- Sett bakgrunn i terminalen for å unngå irriterende svarte kanter
-- Ref: https://www.reddit.com/r/neovim/comments/1b66s2c/sync_terminal_background_with_neovim_background/
vim.api.nvim_create_autocmd({ "VimLeave", "VimSuspend" }, {
  callback = function()
    if vim.env.TMUX then
      io.stdout:write "\027]11;#002b36\027\\"
    else
      io.stdout:write "\027]111;;\027\\"
    end
  end,
})
vim.api.nvim_create_autocmd({ "ColorScheme", "VimResume" }, {
  callback = function()
    local hl_info = vim.api.nvim_get_hl(0, { name = "Normal", link = false })
    io.stdout:write(("\027]11;#%06x\027\\"):format(hl_info.bg))
  end,
})

-- See also: after/plugin/init_autocmds.vim
