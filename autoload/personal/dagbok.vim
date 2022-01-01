function! personal#dagbok#init() abort " {{{1
  silent! normal ,tzv
  autocmd! dagbok
endfunction

" }}}1
function! personal#dagbok#foldlevel(lnum) abort " {{{1
  return getline(a:lnum) =~# '^\d' ? '>1' : '1'
endfunction

" }}}1
