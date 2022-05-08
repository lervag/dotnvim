inoremap <expr> k EscapeKey()

augroup init_escape
  autocmd!
  autocmd InsertCharPre * call EscapeTimer()
augroup END

function EscapeTimer() abort
  if v:char ==# 'j'
    let w:__esc_time_j = reltime()
  elseif v:char !=# 'k'
    let w:__esc_time_j = [0, 0]
  endif
endfunction

function EscapeKey() abort
  let l:timediff = reltimefloat(reltime(get(w:, '__esc_time_j', [0, 0])))
  let w:__esc_time_j = [0, 0]
  return l:timediff <= 0.16 ? "\b\e" : 'k'
endfunction
