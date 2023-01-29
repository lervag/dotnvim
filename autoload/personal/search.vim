function! personal#search#wrap(seq, ...) " {{{1
  if mode() ==# 'c'
        \ && (stridx('/?', getcmdtype()) < 0 || s:ignore_next_cr)
    let s:ignore_next_cr = 0
    return a:seq
  endif

  set hlsearch

  " Optional arg specifies to return to original location after search
  if a:0 > 0
    let s:curpos = getcurpos()
    return a:seq . "\<plug>(trailer-return)"
  endif

  let s:search_motion = v:true

  return a:seq
endfunction

" }}}1
function! personal#search#wrap_visual(search_cmd) abort " {{{1
  let s:search_cmd = a:search_cmd
  return "y<plug>(trailer-visual)"
endfunction

" }}}1


map <expr> <plug>(trailer-return) <sid>trailer_return()
map <expr> <plug>(trailer-visual) <sid>trailer_visual()

function! s:trailer_return() " {{{1
  return s:curpos != getcurpos() ? "''" : ''
endfunction

" }}}1
function! s:trailer_visual() " {{{1
  let s:ignore_next_cr = 1
  let l:seq = s:search_cmd . '\V'
  let l:seq .= substitute(escape(@", '\' . s:search_cmd), "\n", '\\n', 'g')
  let l:seq .= "\<cr>"
  return personal#search#wrap(l:seq, 1)
endfunction

let s:ignore_next_cr = 0

" }}}1


augroup hlsearch
  autocmd!
  autocmd CursorMoved,CursorMovedI * call s:search_checker()
augroup END

function! s:search_checker() " {{{1
  if !s:search_motion | return | endif
  let s:search_motion = v:false

  if foldclosed('.') != -1
    normal! zvzz
  else
    normal! zz
  endif
endfunction

let s:search_motion = v:false

" }}}1
