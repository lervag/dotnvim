vim.opt_local.textwidth = 0
vim.opt_local.wrap = true

vim.keymap.set("n", "<cr>", "<plug>(vimtex-context-menu)", { buffer = true })
vim.keymap.set("n", "K", "<plug>(vimtex-doc-package)", { buffer = true })

-- Ensure statusline is refreshed
vim.api.nvim_create_autocmd("User", {
  pattern = {
    "VimtexEventCompileStarted",
    "VimtexEventCompileStopped",
    "VimtexEventCompileSuccess",
    "VimtexEventCompileFailed",
    "VimtexEventCompiling",
  },
  desc = "Refresh statusline",
  group = vim.api.nvim_create_augroup("init_vimtex", { clear = true }),
  callback = function()
    vim.cmd "redrawstatus"
  end,
})
