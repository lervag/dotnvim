function MyHover()
  if index(['vim', 'help'], &filetype) >= 0
    execute 'help ' . expand('<cword>')
    return
  end

  if &filetype ==# 'neomuttrc'
    let l:cword = expand('<cword>')
    Man neomuttrc
    call search(l:cword)
    return
  end

  if &filetype == 'tex'
    VimtexDocPackage
    return
  end

  call CocAction('doHover')
endfunction

nnoremap <silent> K :<c-u>call MyHover()<cr>
