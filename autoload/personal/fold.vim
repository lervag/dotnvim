function! personal#fold#foldtext() abort " {{{1
  let title = substitute(getline(v:foldstart), '{\{3}\d\?\s*', '', '')
  let title = substitute(title, '^["#! ]\+', '', '')

  return printf(' %s %-s',
        \ ['●', '❚', '▸', '▪', '❺', '❻'][v:foldlevel-1],
        \ title)
endfunction

" }}}1
function! personal#fold#foldlevel_sh(lnum) abort " {{{1
  let l:line = getline(a:lnum)

  if l:line =~# s:sh_re_end
    return 's1'
  endif

  if l:line =~# s:sh_re_start
    return 'a1'
  endif

  return '='
endfunction

let s:sh_re_start = '\v^\s*%(' . join([
      \ 'if>.*%(;\s*then)?$',
      \ '%(while|for).*%(;\s*do)?$',
      \ 'case.*%(\s*in)$',
      \ '%(function\s+)?\S+%(\(\))? \{',
      \], '|') . ')'

let s:sh_re_end = '\v^\s*%(' . join([
      \ 'fi\s*$',
      \ 'done\s*$',
      \ 'esac\s*$',
      \ '\}$',
      \], '|') . ')'

" }}}1
