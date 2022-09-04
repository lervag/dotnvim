augroup init_tmp
  autocmd!
  autocmd BufWritePost spell.vim Runtime autoload/personal/spell.vim
augroup END

function! personal#spell#change_language() abort " {{{1
  let l:lang = input(#{
        \ prompt: 'Set spelllang: ',
        \ completion: 'customlist,personal#spell#completer',
        \})
  if empty(l:lang) || index(s:languages, l:lang) < 0
    return
  endif

  let &l:spelllang = l:lang
  redraw
  echo "spelllang changed to" &l:spelllang
endfunction

" }}}1
function! personal#spell#toggle_language() abort " {{{1
  let l:index = (index(s:languages, &l:spelllang) + 1) % len(s:languages)

  let &l:spelllang = s:languages[l:index]
  redraw
  echo "spelllang changed to" &l:spelllang
endfunction

" }}}1
function! personal#spell#completer(arg_lead, cmd_line, cursor_pos) abort " {{{1
  let l:candidates = filter(
        \ copy(s:languages),
        \ { _, x -> x !=# &l:spelllang })
  return filter(l:candidates, { _, x -> x =~# '^' . a:arg_lead })
endfunction

" }}}1

let s:languages = [
      \ 'en_gb',
      \ 'en_us',
      \ 'nb',
      \ 'nn',
      \]
