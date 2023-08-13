local group = vim.api.nvim_create_augroup("init_help", {})
vim.api.nvim_create_autocmd("InsertEnter", {
  group = group,
  buffer = 0,
  callback = function()
    vim.wo.conceallevel = 0
  end,
})
vim.api.nvim_create_autocmd("InsertLeave", {
  group = group,
  buffer = 0,
  callback = function()
    vim.wo.conceallevel = 2
  end,
})

vim.opt_local.iskeyword:append "-"
vim.wo.foldmethod = "marker"

if not vim.bo.modifiable then
  for lhs, rhs in pairs {
    ["q"] = "<cmd>bwipeout!<cr>",
    ["<cr>"] = "<c-]>",
    ["<bs>"] = "<c-t>",
    ["<c-n>"] = [[/\([\|*']\)\zs\S*\ze\1<cr>n<cmd>set nohlsearch<cr>]],
    ["<c-p>"] = [[?\([\|*']\)\zs\S*\ze\1<cr>]],
  } do
    vim.keymap.set("n", lhs, rhs, { buffer = true, silent = true })
  end
end
