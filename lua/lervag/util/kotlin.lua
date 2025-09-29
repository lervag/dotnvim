local M = {}

function M.indentexpr()
  local lnum = vim.v.lnum
  if lnum == 0 then
    return 0
  end

  local current_line = vim.fn.getline(lnum)

  -- Handle comment continuation
  if current_line:match "^%s*%*" then
    return vim.fn.cindent(lnum)
  end

  local prev_lnum = vim.fn.prevnonblank(lnum - 1)
  if prev_lnum == 0 then
    return 0
  end

  local prev_line = vim.fn.getline(prev_lnum)
  local prev_indent = vim.fn.indent(prev_lnum)

  -- Handle end of block comment
  if prev_line:match "^%s*%*/" then
    local comment_start = prev_lnum - 1
    while
      comment_start > 1 and not vim.fn.getline(comment_start):match "^%s*/%*"
    do
      comment_start = comment_start - 1
    end
    return vim.fn.indent(comment_start)
  end

  -- Check for opening and closing patterns
  local prev_opens_paren = prev_line:match "%(%s*$"
  local prev_opens_brace = prev_line:match "{%s*$" or prev_line:match "%->%s*$"

  local cur_closes_paren = current_line:match "^%s*%)"
  local cur_closes_brace = current_line:match "^%s*}"

  -- Increase indent after opening
  if prev_opens_paren or prev_opens_brace then
    return prev_indent + vim.fn.shiftwidth()
  end

  -- Decrease indent for closing
  if cur_closes_paren or cur_closes_brace then
    return prev_indent - vim.fn.shiftwidth()
  end

  return prev_indent
end

return M
