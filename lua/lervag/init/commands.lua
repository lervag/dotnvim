vim.api.nvim_create_user_command("WinResize", function(_opts)
  require("lervag.windows").resize()
end, {})

vim.api.nvim_create_user_command("WinBufDelete", function(opts)
  require("lervag.windows").buf_delete(opts.bang, opts.args or "")
end, {
  bang = true,
  complete = "buffer",
  nargs = "?",
})
