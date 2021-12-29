require "zen-mode".setup {
  window = {
    backdrop = 1,
    width = 80,
    height = 1,
  },
  plugins = {
    tmux = { enabled = true },
  },
  on_open = function(win)
    vim.cmd [[
      call system('xdotool key --window $(xdotool getactivewindow) "super+f"')
    ]]
  end,
  on_close = function()
    vim.cmd [[
      call system('xdotool key --window $(xdotool getactivewindow) "super+f"')
    ]]
  end,
}

vim.api.nvim_set_keymap("n", "<leader>z", ":<c-u>ZenMode<cr>",
  { noremap = true, silent = true })
