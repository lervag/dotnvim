function! personal#fold#foldtext() abort " {{{1
  let title = substitute(getline(v:foldstart), '{\{3}\d\?\s*', '', '')
  let title = substitute(title, '^["#! ]\+', '', '')

  return printf(' %s %-s',
        \ ['●', '❚', '▸', '▪', '❺', '❻'][v:foldlevel-1],
        \ title)
endfunction

" }}}1
