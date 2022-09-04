augroup init_tmp
  autocmd!
  autocmd BufWritePost spell.vim Runtime autoload/personal/spell.vim
augroup END

function! personal#spell#change_language(lang) abort " {{{1
  if empty(a:lang) || index(s:languages, a:lang) < 0
    return
  endif

  let &l:spelllang = a:lang
  redraw
  echo "spelllang changed to" &l:spelllang

  if a:lang =~# '^en'
    set thesaurus=$HOME/.config/nvim/spell/thesaurus-en.txt
  else
    set thesaurus=$HOME/.config/nvim/spell/thesaurus-no.txt
  endif
endfunction

" }}}1
function! personal#spell#change_language_ask() abort " {{{1
  let l:lang = input(#{
        \ prompt: 'Set spelllang: ',
        \ completion: 'customlist,personal#spell#completer',
        \})
  return personal#spell#change_language(l:lang)
endfunction

" }}}1
function! personal#spell#toggle_language() abort " {{{1
  let l:index = (index(s:languages, &l:spelllang) + 1) % len(s:languages)

  return personal#spell#change_language(s:languages[l:index])
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
