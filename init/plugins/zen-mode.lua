require "zen-mode".setup {
  window = {
    backdrop = 1,
    width = 120,
    height = 1,
  },
  plugins = {
    tmux = { enabled = true },
  },
  on_open = function(_)
    vim.cmd [[
      call system('xdotool windowstate --toggle FULLSCREEN $(xdotool getactivewindow)')
    ]]
  end,
  on_close = function()
    vim.cmd [[
      call system('xdotool windowstate --toggle FULLSCREEN $(xdotool getactivewindow)')
    ]]
  end,
}

vim.keymap.set("n", "<leader>z", "<cmd>ZenMode<cr>")
