vim.pack.add { "https://github.com/samharju/yeet.nvim" }

require("yeet").setup {
  clear_before_yeet = false,
  cache_window_opts = function()
    local width = math.min(math.ceil(0.6 * vim.o.columns), 120)
    local height = math.min(15, vim.o.lines - 4)

    return {
      relative = "editor",
      row = (vim.o.lines - height) * 0.5,
      col = (vim.o.columns - width) * 0.5,
      width = width,
      height = height,
      border = require("lervag.const").border,
      title = " Yeet ",
      title_pos = "center",
    }
  end,
}

vim.keymap.set("n", "<leader>is", function()
  require("yeet").execute(vim.api.nvim_get_current_line(), {
    yeet_and_run = true,
    clear_before_yeet = false,
  })
end)
vim.keymap.set("v", "<leader>is", function()
  require("yeet").execute_selection {
    yeet_and_run = true,
    clear_before_yeet = false,
  }
end)
vim.keymap.set("n", "<leader>ii", require("yeet").execute)
vim.keymap.set("n", "<leader>io", require("yeet").list_cmd)
vim.keymap.set("n", "<leader>iq", function()
  require("yeet").setqflist { open = true }
end)
