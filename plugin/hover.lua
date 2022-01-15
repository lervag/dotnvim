function MyHover()
  if vim.tbl_contains({ 'vim', 'help' }, vim.bo.filetype) then
    vim.cmd [[execute 'help ' . expand('<cword>')]]
    return
  end

  if vim.bo.filetype == 'neomuttrc' then
    local cword = vim.fn.expand('<cword>')
    vim.cmd [[Man neomuttrc]]
    vim.fn.search(cword)
    return
  end

  if vim.bo.filetype == 'tex' then
    vim.cmd 'VimtexDocPackage'
    return
  end

  vim.fn.CocAction('doHover')
end

vim.keymap.set('n', 'K', MyHover, { noremap=true, silent=true })