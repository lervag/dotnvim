function! personal#kotlin#indentexpr()
  if v:lnum == 0 | return 0 | endif

  let l:cur = getline(v:lnum)
  if l:cur =~# '^\s*\*' | return cindent(v:lnum) | endif

  let l:prev_lnum = prevnonblank(v:lnum - 1)
  let l:prev_line = getline(l:prev_lnum)
  let l:prev_indent = indent(l:prev_lnum)

  if l:prev_line =~# '^\s*\*/'
    let l:lnum = l:prev_lnum - 1
    while l:num > 1 && getline(l:lnum) !~# '^\s*/\*'
      let l:lnum -= 1
    endwhile
    return indent(l:lnum)
  endif

  let l:prev_openp = l:prev_line =~# '^.*(\s*$'
  let l:prev_openb = l:prev_line =~# '^.*\({\|->\)\s*$'
  let l:cur_closep = l:cur =~# '^\s*).*$'
  let l:cur_closeb = l:cur =~# '^\s*}.*$'

  if l:prev_openp && !l:cur_closep || l:prev_openb && !l:cur_closeb
    return l:prev_indent + shiftwidth()
  endif

  if l:cur_closep && !l:prev_openp || l:cur_closeb && !l:prev_openb
    return l:prev_indent - shiftwidth()
  endif

  return l:prev_indent
endfunction
