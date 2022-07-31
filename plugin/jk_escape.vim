inoremap <expr> k EscapeKey()

augroup init_escape
  autocmd!
  autocmd InsertCharPre *
        \ let w:__esc_time_j = v:char ==# 'j' ? reltime() : [0, 0]
augroup END

function! EscapeKey() abort
  let l:timediff = reltimefloat(reltime(get(w:, '__esc_time_j', [0, 0])))
  let w:__esc_time_j = [0, 0]
  return l:timediff <= 0.25 ? "\b\e" : 'k'
endfunction
