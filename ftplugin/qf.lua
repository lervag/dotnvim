vim.wo.wrap = false
vim.bo.buflisted = false

vim.api.nvim_create_user_command(
  "QDeleteLine",
  "silent call personal#qf#delete_line(<line1>, <line2>)",
  {
    bar = true,
    range = true,
  }
)

vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = true })
vim.keymap.set("n", "d", ":set opfunc=personal#qf#delete_line<cr>g@", { buffer = true })
vim.keymap.set({"n", "x"}, "dd", ":QDeleteLine<cr>", { buffer = true, silent = true })
vim.keymap.set("n", "f", ":silent call personal#qf#filter(1)<cr>", { buffer = true, silent = true })
vim.keymap.set("n", "F", ":silent call personal#qf#filter(0)<cr>", { buffer = true, silent = true })
vim.keymap.set("n", "<left>", ":call personal#qf#older()<cr>", { buffer = true, silent = true })
vim.keymap.set("n", "<right>", ":call personal#qf#newer()<cr>", { buffer = true, silent = true })

group = vim.api.nvim_create_augroup("init_qf", { clear = true })
vim.api.nvim_create_autocmd("BufReadPost", {
  group = group,
  pattern = "quickfix",
  command = [[call personal#qf#adjust_height()]]
})
vim.api.nvim_create_autocmd("BufEnter", {
  group = group,
  buffer = 0,
  nested = true,
  command = [[if winnr('$') < 2 | q | endif]]
})
vim.api.nvim_create_autocmd("QuitPre", {
  group = group,
  nested = true,
  command = [[if &filetype != 'qf' | silent! lclose | endif]]
})
