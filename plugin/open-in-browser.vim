function! OpenInBrowser()
  let url = expand('<cWORD>')

  " Remove surrounding delimiters
  let url = substitute(url, '^[''"\[({<]\+\(.\{-}\)[''",.\])}>]\+$', '\1', '')

  " Parse bundle urls
  if url =~# '^[a-zA-Z][a-zA-Z0-9_.-]*\/[a-zA-Z][a-zA-Z0-9_.-]*$'
    let url = 'https://github.com/' . url
  endif

  " Check if url is valid
  if url =~#     '\(\(https\?\|ftp\|git\)://\)\?'
             \ . '[a-zA-Z0-9][a-zA-Z0-9_-]*'
             \ . '\(\.[a-zA-Z0-9][a-zA-Z0-9_-]*\)\+\(:\d\+\)\?'
             \ . '\(/[a-zA-Z0-9_/.+%#?&=;@$,!''*~-]*\)\?'
    silent execute '!xdg-open ' . shellescape(url,1) . '&'
  endif
endfunction

nnoremap <silent> gx :call OpenInBrowser()<cr>
