local M = {}

function M.foldtext_packages()
  local lnum = vim.v.foldstart - 1
  if vim.v.foldlevel == 2 then
    lnum = lnum + 1
    local line = vim.api.nvim_buf_get_lines(
      0,
      lnum,
      lnum + 1,
      true
    )[1]
    line = line:gsub([[url = "git@github%.com:]], '"')
    line = line:gsub([[^%s*"]], '  ')
    line = line:gsub([[",$]], '')
    return line
  end

  local line = vim.api.nvim_buf_get_lines(
    0,
    lnum,
    lnum + 1,
    true
  )[1]

  return line
end

return M
