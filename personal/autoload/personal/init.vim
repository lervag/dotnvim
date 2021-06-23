function! personal#init#cursor() abort " {{{1
  set guicursor=a:block
  set guicursor+=n:Cursor
  set guicursor+=o-c:iCursor
  set guicursor+=v:vCursor
  set guicursor+=i-ci-sm:ver30-iCursor
  set guicursor+=r-cr:hor20-rCursor
  set guicursor+=a:blinkon0
endfunction

" }}}1
function! personal#init#statusline() abort " {{{1
  augroup statusline
    autocmd!
    autocmd VimEnter,WinEnter,BufWinEnter   * call personal#statusline#refresh()
    autocmd FileType,VimResized             * call personal#statusline#refresh()
    autocmd BufHidden,BufWinLeave,BufUnload * call personal#statusline#refresh()
  augroup END
endfunction

" }}}1
function! personal#init#tabline() " {{{1
  set tabline=%!personal#tabline#get_tabline()
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
function! personal#init#toggle_diff() abort " {{{1
  if v:option_new
    set nocursorline
  else
    set cursorline
  endif
endfunction

" }}}1
