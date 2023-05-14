function! personal#wiki#file_handler(resolved, ...) abort " {{{1
  if a:resolved.path =~# '\.pdf$'
    call jobstart(
          \ ['sioyek', a:resolved.path],
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
    let l:link = !has_key(a:ctx.origin, 'pos_start')
          \ ? personal#wiki#file_to_link(a:ctx.origin.origin)
          \ : personal#wiki#file_to_link(a:ctx.origin.origin,
          \                              a:ctx.origin.pos_start[0])

    call append(1, [
          \ '',
          \ 'Sjå også:',
          \ '* ' . l:link
          \])
  endif

  call cursor(2, 1)
endfunction

" }}}1
function! personal#wiki#file_to_link(filename, ...) abort " {{{1
  let l:page = wiki#paths#shorten_relative(a:filename)
  let l:page = fnamemodify(l:page, ':r')

  if a:0 > 0
    let l:a = []
    for l:e in wiki#toc#gather_entries(#{lines: readfile(a:filename)})
      if l:e.lnum > a:1 | break | endif
      let l:a = l:e.anchors
    endfor

    let l:anchors = join(l:a, '#')
    if !empty(l:anchors) && l:anchors !=# l:page
      let l:page .= '#' . l:anchors
    endif
  endif

  return '[[' . l:page . ']]'
endfunction

" }}}1
