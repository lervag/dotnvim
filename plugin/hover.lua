vim.keymap.set("n", "K", function()
  local line_number = vim.fn.line "."
  for _, pattern in ipairs {
    [[wiki:\zs[^ ]\+]],
    [[<wiki:\zs[^>]\+>]],
    [=[\[wiki:\zs[^]]\+\]]=],
  } do
    local matches = vim.fn.matchbufline(
      "%",
      [[\%<.c]] .. pattern .. [[\%>.c]],
      line_number,
      line_number
    )
    if not vim.tbl_isempty(matches) then
      vim.cmd.WikiOpen(matches[1].text)
      return
    end
  end

  local cword = vim.fn.expand "<cword>"
  if vim.tbl_contains({ "vim", "help" }, vim.bo.filetype) then
    vim.cmd.help(cword)
    return
  end

  if vim.bo.filetype == "neomuttrc" then
    vim.cmd.Man "neomuttrc"
    vim.fn.search(cword)
    return
  end

  if not vim.tbl_isempty(vim.lsp.get_clients()) then
    vim.lsp.buf.hover()
  end
end)
