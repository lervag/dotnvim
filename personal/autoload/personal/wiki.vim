function! personal#wiki#file_handler(...) abort dict " {{{1
  if self.path =~# 'pdf$'
    silent execute '!zathura' fnameescape(self.path) '&'
    return 1
  endif

  if self.path =~# '\v(png|jpg)$'
    silent execute '!feh -.' fnameescape(self.path) '&'
    return 1
  endif

  if self.path =~# '\v(svg)$'
    silent execute '!display -.' fnameescape(self.path) '&'
    return 1
  endif

  if self.path =~# '\v(doc|xls|ppt)x?$'
    silent execute '!libreoffice' fnameescape(self.path) '&'
    return 1
  endif
endfunction

" }}}1
function! personal#wiki#open_diary() abort " {{{1
  " Connection between calendar.vim and wiki plugin
  let l:date = printf('%d-%0.2d-%0.2d',
        \ b:calendar.day().get_year(),
        \ b:calendar.day().get_month(),
        \ b:calendar.day().get_day())

  call wiki#journal#make_note(l:date)
endfunction

" }}}1
function! personal#wiki#template(ctx) abort " {{{1
  call append(0, '# ' . a:ctx.name)

  if !empty(a:ctx.origin)
    call append(1, [
          \ '',
          \ 'Sjå også:',
          \ '* ' . personal#wiki#file_to_link(
          \   a:ctx.origin.origin,
          \   a:ctx.origin.pos_start[0]),
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
    for l:e in wiki#page#gather_toc_entries(readfile(a:filename), v:false)
      if l:e.lnum > a:1 | break | endif
      let l:a = l:e.anchors
    endfor

    if !empty(l:a)
      let l:page .= '#' . join(l:a, '#')
    endif
  endif

  return '[[' . l:page . ']]'
endfunction

" }}}1
