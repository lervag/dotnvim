require "zen-mode".setup {
  window = {
    backdrop = 1,
    width = 80,
    height = 1,
  },
  plugins = {
    tmux = { enabled = true },
  },
  on_open = function(_)
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

vim.keymap.set("n", "<leader>z", "<cmd>ZenMode<cr>")
