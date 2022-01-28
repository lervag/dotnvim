function! personal#search#wrap(seq, ...)
  let l:opts = a:0 > 0 ? a:1 : {}

  if mode() ==# 'c' && stridx('/?', getcmdtype()) < 0
    return a:seq
  endif

  set hlsearch

  if get(l:opts, 'immobile')
    let s:curpos = getcurpos()
    return a:seq . "\<plug>(hl-trailer-return)"
  endif

  return a:seq
endfunction

function! personal#search#wrap_visual(search_cmd) abort
  let s:search_cmd = a:search_cmd
  return "y\<plug>(hl-trailer-visual)"
endfunction


map <silent><expr> <plug>(hl-trailer-return) <sid>trailer_return()
map <silent><expr> <plug>(hl-trailer-visual) <sid>trailer_visual()

function! s:trailer_return()
  return s:curpos != getcurpos() ? "''" : ''
endfunction

function! s:trailer_visual()
  let l:seq = s:search_cmd . '\V'
  let l:seq .= substitute(escape(@", '\' . s:search_cmd), "\n", '\\n', 'g')
  let l:seq .= "\<cr>"
  return personal#search#wrap(l:seq, {'immobile': 1})
endfunction
