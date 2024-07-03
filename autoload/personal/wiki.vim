function! personal#wiki#file_handler(resolved, ...) abort " {{{1
  if a:resolved.path =~# '\.pdf$'
    call jobstart(
          \ ['zathura', a:resolved.path],
          \ { 'detach': 1 })
    return
  endif

  if a:resolved.path =~# '\v\.(png|jpg)$'
    silent execute '!feh -.' fnameescape(a:resolved.path) '&'
    return
  endif

  if a:resolved.path =~# '\.svg$'
    silent execute '!display -.' fnameescape(a:resolved.path) '&'
    return
  endif

  if a:resolved.path =~# '\v\.(doc|xls|ppt)x?$'
    silent execute '!libreoffice' fnameescape(a:resolved.path) '&'
    return
  endif

  if filereadable(a:resolved.path)
    silent execute 'edit' fnameescape(a:resolved.path)
    return
  endif

  let l:cmd = get(g:wiki_viewer, a:resolved.ext, g:wiki_viewer._)
  if l:cmd ==# ':edit'
    silent execute 'edit' fnameescape(a:resolved.path)
  else
    call wiki#jobs#run(l:cmd . ' ' . shellescape(a:resolved.path) . '&')
  endif
endfunction

" }}}1
function! personal#wiki#template(ctx) abort " {{{1
  call append(0, '# ' . a:ctx.name)

  if !empty(a:ctx.origin)
    call append(1, [
          \ '',
          \ 'Sjå også:',
          \ '* ' . personal#wiki#get_origin_link(a:ctx.origin)
          \])
  endif

  call cursor(2, 1)
endfunction

" }}}1
function! personal#wiki#get_origin_link(origin) abort " {{{1
  let l:page = wiki#paths#shorten_relative(a:origin.file)
  let l:page = fnamemodify(l:page, ':r')

  let l:a = []
  for l:e in wiki#toc#gather_entries(#{lines: readfile(a:origin.file)})
    if l:e.lnum > a:origin.cursor[1] | break | endif
    let l:a = l:e.anchors
  endfor

  let l:anchors = join(l:a, '#')
  if !empty(l:anchors) && l:anchors !=# l:page
    let l:page .= '#' . l:anchors
  endif

  return '[[' . l:page . ']]'
endfunction

" }}}1
function! personal#wiki#link_from_clipboard() abort " {{{1
  let l:url = getreg('+')

  if !executable('pup')
    echo "Consider installing pup!"
    return printf('[](%s)', l:url)
  endif

  let l:text = trim(system(printf("curl -s %s | pup 'h1 text{}'", l:url)))
  return printf("[%s](%s)\n", l:text, l:url)
endfunction

" }}}1
