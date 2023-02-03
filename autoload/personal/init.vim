function! personal#init#command_line_win() " {{{1
  nnoremap <buffer> q     <c-c><c-c>
  nnoremap <buffer> <c-f> <c-c>
endfunction

" }}}1

function! personal#init#go_to_last_known_position() abort " {{{1
  if line("'\"") <= 0 || line("'\"") > line('$')
    return
  endif

  normal! g`"
  if &foldlevel == 0
    normal! zMzvzz
  endif
endfunction

" }}}1

function! personal#init#toggle_cursorline(on) abort " {{{1
  if a:on && &buflisted
    setlocal cursorline
  else
    setlocal nocursorline
  endif
endfunction

" }}}1
