local M = {}

function M.toggle_fugitive()
  local bufnr = vim.fn.bufnr(".git//$")
  if vim.fn.buflisted(bufnr) > 0 then
    vim.cmd.bdelete (bufnr)
    return
  end

  local ok, _ = pcall(vim.cmd.Git)
  if ok then
    vim.cmd.normal "gg)"
  else
    vim.notify("Not in a Git repo!")
  end
end

return M
