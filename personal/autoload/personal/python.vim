function! personal#python#includexpr()
  let line = getline('.')
  let fname = substitute(v:fname, '\.', '/', 'g')

  if line =~# '^\s*from'
    let pre = matchstr(line, '^\s*from \zs\S*')
    let pre = substitute(pre, '^\.\.', '../', '')
    let pre = substitute(pre, '^\.', '', '')
    let pre = substitute(pre, '\w\zs\.', '/', 'g')

    for cand in [
          \ findfile(pre . '/' . fname),
          \ findfile(pre),
          \ findfile(pre . '/__init__.py'),
          \ pre,
          \]
      if filereadable(cand)
        return cand
      endif
    endfor

    return ''
  else
    return substitute(matchstr(line, '^\s*import \zs\S*'), '\.', '/', 'g')
  endif
endfunction

function! personal#python#set_path()
  let &l:path = &path

  " Add standard python paths
  python3 << EOF
import os
import sys
import vim
for p in sys.path:
    # Add each directory in sys.path, if it exists.
    if os.path.isdir(p):
        # Command 'set' needs backslash before each space.
        vim.command(r"setlocal path+=%s" % (p.replace(" ", r"\ ")))
EOF

  " Add package root to path
  let path = expand('%:p:h')
  let top_level = ''
  while len(path) > 1
    if filereadable(path . '/__init__.py')
      let top_level = path
    endif
    let path = fnamemodify(path, ':h')
  endwhile

  if !empty(top_level)
    let &l:path .= ',' . top_level . '/**'
  endif
endfunction

function! personal#python#foldexpr(lnum) abort
  let line = getline(a:lnum)
  let level = indent(a:lnum)/&shiftwidth

  " Specify where folds open
  if line =~# s:re_foldopen
    if getline(a:lnum - 1) =~# '^\s*@\w\+' | return '=' | endif
    return '>' . (level+1)
  endif

  " Folds should only end on empty lines and hide as many empty lines as is
  " convenient
  if !empty(line) | return '=' | endif
  if empty(getline(a:lnum+1)) | return '=' | endif

  " Get level of previous fold
  let prev_lnum = prevnonblank(a:lnum - 1)
  let prev_level_r = indent(prev_lnum)/&shiftwidth
  while prev_lnum > 0
    if match(getline(prev_lnum), s:re_foldopen) >= 0
      let prev_level = indent(prev_lnum)/&shiftwidth
      if prev_level < prev_level_r | break | endif
    else
      let prev_level_r = min([prev_level_r, indent(prev_lnum)/&shiftwidth])
    endif
    let prev_lnum = prevnonblank(prev_lnum - 1)
  endwhile

  if prev_lnum == 0 | return 0 | endif

  let next_line = getline(a:lnum + 1)
  let next_level = indent(a:lnum + 1)/&shiftwidth
  if next_line =~# '^\s*\%(def\|class\) '
    return next_level < prev_level ? next_level : '='
  else
    return next_level < prev_level+1 ? next_level : '='
  endif
endfunction

let s:re_foldopen = '^\s*\%(def \|class \|@\w\+\)'

" vim: fdm=syntax
