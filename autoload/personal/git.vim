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
  if flog#has_commit_mark('m')
    call flog#remove_commit_mark('m')
  endif
  call flog#run_command('vertical botright Gsplit %p', 0, 0, 1)
endfunction

" }}}1
function! personal#git#display_file() abort " {{{1
  call flog#set_commit_mark_at_line('m', '.')
  call flog#run_command('vertical botright Gsplit %h:%p', 0, 0, 1)
endfunction

" }}}1
function! personal#git#diff_file() abort " {{{1
  if flog#has_commit_mark('m')
    call flog#run_command(
          \ "vertical botright Gsplit %h:%p \| Gdiffsplit %(h'm)",
          \ 0, 0, 1)
  else
    call flog#run_command(
          \ "vertical botright Gsplit %h:%p \| Gdiffsplit %p",
          \ 0, 0, 1)
  endif
endfunction

" }}}1
