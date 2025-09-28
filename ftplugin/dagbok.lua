function GetDagbokIndent(lnum_in)
  if lnum_in == 1 then
    return 0
  end

  -- Zero indent for first line of each entry
  local cline = vim.fn.getline(lnum_in)
  if cline:match "^%d+" then
    return 0
  end

  -- Indent 18 for continuation of notes
  local pline = vim.fn.getline(lnum_in - 1)
  if pline:match "^%s+Notat" then
    return 18
  elseif pline:match "^%s+Snop" then
    return 18
  elseif pline:match "^%d+" then
    return 2
  end

  return vim.fn.indent(lnum_in - 1)
end

vim.wo.signcolumn = "no"
vim.wo.foldmethod = "expr"
vim.wo.foldexpr = "getline(v:lnum) =~# '^\\d' ? '>1' : '1'"

vim.opt_local.formatoptions:remove "n"
vim.bo.indentexpr = "v:lua.GetDagbokIndent(v:lnum)"

vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "dagbok.txt",
  once = true,
  command = [[silent! normal {,tlzv]],
})

for lhs, rhs in pairs {
  [",t"] = [[/\C\%18c \?x<cr>]],
  [",n"] = function()
    vim.cmd.normal "Gonew"
    MiniSnippets.expand()
  end,
  [",a"] = function()
    vim.cmd.normal "zR"
    vim.fn.search("^2006-10-23", "w")
    vim.cmd.normal "{{2yy}Pj$"
    require("dial.map").manipulate("increment", "normal")
    vim.cmd.normal "oadd"
    MiniSnippets.expand()
  end,
} do
  vim.keymap.set("n", lhs, rhs, { buffer = true, silent = true })
end
