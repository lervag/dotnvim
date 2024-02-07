nnoremap <silent> <plug>(align) :set opfunc=<sid>align<cr>g@
vnoremap <silent> <plug>(align) :<c-u>call <sid>align(visualmode(), 1)<cr>
nnoremap <silent> <plug>(align-repeat) :call <sid>repeat()<cr>
vnoremap <silent> <plug>(align-repeat) :<c-u>call <sid>repeatv()<cr>

function! s:align(type, ...)
  let vmode = a:0

  if !&modifiable
    if vmode
      normal! gv
    endif
    return
  endif
  let sel_save = &selection
  let &selection = "inclusive"

  if vmode
    let vmode = a:type
    let [l1, l2] = ["'<", "'>"]
    let s:last_visual = [
          \ vmode,
          \ s:abs(line("'>") - line("'<")),
          \ s:abs(col("'>") - col("'<"))
          \]
  else
    let vmode = ''
    let [l1, l2] = [line("'["), line("']")]
    unlet! s:last_visual
  endif

  try

    let range = l1.','.l2
    if get(g:, 'easy_align_need_repeat')
      execute range . g:easy_align_last_command
    else
      execute range . "call easy_align#align(0, 1, vmode, '')"
    end
    silent! call repeat#set("\<plug>(align-repeat)")
  finally
    let &selection = sel_save
  endtry
endfunction

function! s:repeat()
  if exists('s:last_visual')
    call s:repeat_visual()
  else
    try
      let g:easy_align_need_repeat = 1
      normal! .
    finally
      unlet! g:easy_align_need_repeat
    endtry
  endif
endfunction

function! s:repeatv()
  if exists('g:easy_align_last_command')
    let s:last_visual = [
          \ visualmode(),
          \ s:abs(line("'>") - line("'<")),
          \ s:abs(col("'>") - col("'<"))
          \]
    call s:repeat_visual()
  endif
endfunction

function! s:repeat_visual()
  let [mode, ldiff, cdiff] = s:last_visual
  let cmd = 'normal! '.mode
  if ldiff > 0
    let cmd .= ldiff . 'j'
  endif

  let ve_save = &virtualedit
  try
    if mode == "\<C-V>"
      if cdiff > 0
        let cmd .= cdiff . 'l'
      endif
      set virtualedit+=block
    endif
    execute cmd.":\<C-r>=g:easy_align_last_command\<Enter>\<Enter>"
    silent! call repeat#set("\<plug>(align-repeat)")
  finally
    if ve_save != &virtualedit
      let &virtualedit = ve_save
    endif
  endtry
endfunction

function! s:abs(v)
  return a:v >= 0 ? a:v : - a:v
endfunction
