local function VimHelp()
  vim.cmd [[execute 'help ' . expand('<cword>')]]
end

function MyHover()
  if vim.tbl_contains({ 'vim', 'help' }, vim.bo.filetype) then
    VimHelp()
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

  if vim.bo.filetype == 'lua' and pcall(VimHelp) then
    return
  end

  if not vim.tbl_isempty(vim.lsp.buf_get_clients()) then
    vim.lsp.buf.hover()
  end
end

vim.keymap.set('n', 'K', MyHover)
