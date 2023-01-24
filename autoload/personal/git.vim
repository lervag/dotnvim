function! personal#git#fugitive_toggle() " {{{1
  if buflisted(bufname('.git/index'))
    bd .git/index
  else
    try
      Git
      normal gg)
    catch /Vim.*E492/
      echo 'Sorry: Not in a Git repo.'
    endtry
  endif
endfunction

" }}}1

function! personal#git#display_file_current() abort " {{{1
  let l:state = flog#state#GetBufState()

  if flog#state#HasCommitMark(l:state, 'm')
    call flog#state#RemoveCommitMark(l:state, 'm')
  endif

  call flog#ExecTmp(flog#Format('vertical botright Gsplit %p'), 0, 0)
endfunction

" }}}1
function! personal#git#display_file() abort " {{{1
  call flog#floggraph#mark#Set('m', '.')
  call flog#ExecTmp(flog#Format('vertical botright Gsplit %h:%p'), 0, 0)
endfunction

" }}}1
function! personal#git#diff_file() abort " {{{1
  let l:state = flog#state#GetBufState()

  if flog#state#HasCommitMark(l:state, 'm')
    call flog#ExecTmp(
          \ flog#Format("vertical botright Gsplit %h:%p \| Gdiffsplit %(h'm)"),
          \ 0, 0)
  else
    call flog#ExecTmp(
          \ flog#Format("vertical botright Gsplit %h:%p \| Gdiffsplit %p"),
          \ 0, 0)
  endif
endfunction

" }}}1
