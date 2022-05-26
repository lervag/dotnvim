"
" Tabline functions
"

function! personal#tabline#get_tabline() " {{{1
  let s = ''
  let l:tab = tabpagenr()
  for i in range(1, tabpagenr('$'))
    let s .= s:color(
          \ '%{personal#tabline#get_tablabel(' . i . ')}',
          \ 'TabLineSel', i == l:tab)
  endfor

  return s
endfunction

" }}}1
function! personal#tabline#get_tablabel(n) " {{{1
  let buflist = tabpagebuflist(a:n)
  let winnr = tabpagewinnr(a:n)

  let name = bufname(buflist[winnr - 1])
  if empty(name)
    let type = getbufvar(buflist[winnr - 1], '&buftype')
    if type !=# ''
      let label = ' [' . type . '] '
    else
      let label = ' [No Name] '
    endif
  else
    let label = fnamemodify(name, ':t')
  endif

  return printf('  %s ', label)
endfunction

" }}}1

function! s:color(content, group, active) " {{{1
  if a:active
    return '%#' . a:group . '#' . a:content . '%*'
  else
    return a:content
  endif
endfunction

" }}}1
