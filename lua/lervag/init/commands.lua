vim.api.nvim_create_user_command("WinResize", function(_opts)
  require("lervag.windows").resize()
end, {})
