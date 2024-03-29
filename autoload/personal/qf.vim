function! personal#qf#adjust_height() abort " {{{1
  execute max([2, min([line('$') + 1, &lines/2])]) . 'wincmd _'
endfunction

" }}}1
function! personal#qf#delete_line(...) abort " {{{1
  if a:0 == 1 && type(a:1) == type('')
    " called from g@
    let [l1, l2] = [line("'["), line("']")]
  elseif a:0 == 2
    " called from cmdline
    let [l1, l2] = [a:1, a:2]
  else
    echom 'Argument error (kickfix#QDeleteLine)'
    return
  endif

  let curline = line('.')

  if personal#qf#is_loc()
    let l:oldqf = getloclist(0)
  else
    let l:oldqf = getqflist()
  endif

  let nqf = copy(l:oldqf)
  call remove(nqf, l1 - 1, l2 - 1)

  if personal#qf#is_loc()
    call setloclist(0, nqf, 'r')
  else
    call setqflist(nqf, 'r')
  endif

  call cursor(curline, 0)
endfunction

" }}}1
function! personal#qf#filter(include) abort " {{{1
  let l:rx = input(a:include ? 'Filter (include): ' : 'Filter (remove): ')

  if personal#qf#is_loc()
    let l:list = getloclist(0, {'all': 1})
  else
    let l:list = getqflist({'all': 1})
  endif

  let l:new = []
  for l:entry in l:list.items
    let l:string = bufname(l:entry.bufnr) . ' | ' . l:entry.text
    if (a:include && match(l:string, l:rx) >= 0)
          \ || (!a:include && match(l:string, l:rx) < 0)
      call add(l:new, copy(l:entry))
    endif
  endfor

  if personal#qf#is_loc()
    call setloclist(0, l:new, 'r')
  else
    call setqflist(l:new, 'r')
    call setqflist([], 'r', {'title': l:list.title})
  endif
endfunction

" }}}1
function! personal#qf#older() abort " {{{1
  return s:history(0)
endfunction

" }}}1
function! personal#qf#newer() abort " {{{1
  return s:history(1)
endfunction

" }}}1
function! personal#qf#is_loc(...) abort " {{{1
  let l:winnr = a:0 > 0 ? a:1 : winnr()
  let l:wininfo = filter(getwininfo(), {i,v -> v.winnr == l:winnr})[0]
  return l:wininfo.loclist
endfunction

" }}}1isLast
function! personal#qf#get_prop(key, val, ...) abort " {{{1
  let l:what = {a:key : a:val}
  let l:winnr = a:0 > 0 ? a:1 : winnr()

  let l:listdict = personal#qf#is_loc(l:winnr)
        \ ? getloclist(l:winnr, l:what) : getqflist(l:what)
  return get(l:listdict, a:key)
endfunction

" }}}1
function! personal#qf#length(...) abort " {{{1
  let l:winnr = a:0 > 0 ? a:1 : winnr()

  if empty(getqflist({'size': 0}))
    return len(personal#qf#is_loc(l:winnr) ? getloclist(l:winnr) : getqflist())
  else
    return personal#qf#get_prop('size', 0, l:winnr)
  endif
endfunction

" }}}1

function! s:history(forward) abort " {{{1
  let l:cmd = (personal#qf#is_loc() ? 'l' : 'c')
        \ . (a:forward ? 'newer' : 'older')

  while 1
    if (a:forward && s:is_last()) || (!a:forward && s:is_first()) | break | endif
    silent execute cmd
    if personal#qf#length() | break | endif
  endwhile

  call personal#qf#adjust_height()
endfunction

" }}}1
function! s:is_first() abort " {{{1
  return personal#qf#get_prop('nr', 0) <= 1
endfunction

" }}}1
function! s:is_last() abort " {{{1
  return personal#qf#get_prop('nr', 0) == personal#qf#get_prop('nr', '$')
endfunction

" }}}1
