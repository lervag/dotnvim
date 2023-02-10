"
" Statusline functions
"
" Inspiration:
" - https://github.com/blaenk/dots/blob/master/vim/.vimrc
" - http://www.blaenkdenum.com/posts/a-simpler-vim-statusline/
"

function! personal#statusline#refresh() abort " {{{1
  call map(
        \ filter(
        \   range(1, winnr('$')),
        \   { _, x -> bufname(winbufnr(x)) !~# '^\%(undotree\|diffpanel\)' }),
        \ { _, x -> setwinvar(x, '&statusline', '%!personal#statusline#main(' . x . ')')})
endfunction

"}}}1
function! personal#statusline#main(winnr) abort " {{{1
  let l:ctx = deepcopy(s:ctx)
  let l:ctx.winnr = winbufnr(a:winnr) == -1 ? 1 : a:winnr
  let l:ctx.bufnr = winbufnr(l:ctx.winnr)
  let l:ctx.active = l:ctx.winnr == winnr()

  try
    let l:buftype = getbufvar(l:ctx.bufnr, '&buftype')
    return s:bt_{l:buftype}(l:ctx)
  catch /E117: Unknown function/
  endtry


  try
    let l:match = matchstr(bufname(l:ctx.bufnr), '^\w\+\ze:\/\/')
    if !empty(l:match)
      return s:scheme_{l:match}(l:ctx)
    endif
  catch /E117: Unknown function/
  endtry


  try
    let l:filetype = getbufvar(l:ctx.bufnr, '&filetype')
    return s:ft_{l:filetype}(l:ctx)
  catch /E117: Unknown function/
  endtry


  return s:fallback(l:ctx)
endfunction

" }}}1


function! s:bt_help(ctx) abort " {{{1
  return a:ctx.info(' vimdoc: ')
        \ . a:ctx.hlight(
        \     fnamemodify(bufname(a:ctx.bufnr), ':t:r'))
endfunction

" }}}1
function! s:bt_quickfix(ctx) abort " {{{1
  let l:stat = ' ['
  let l:stat .= personal#qf#is_loc(a:ctx.winnr) ? 'Loclist' : 'Quickfix'
  let l:qf_last = personal#qf#get_prop('nr', '$', a:ctx.winnr)
  if l:qf_last > 1
    let l:qf_nr = personal#qf#get_prop('nr', 0, a:ctx.winnr)
    let l:stat .= ' ' . l:qf_nr . '/' . l:qf_last
  endif

  let l:stat .= '] (' . personal#qf#length(a:ctx.winnr) . ') '

  let l:stat .= personal#qf#get_prop('title', 0, a:ctx.winnr)

  return a:ctx.hlight(l:stat)
endfunction

" }}}1

function! s:scheme_fugitive(ctx) abort " {{{1
  let l:bufname = bufname(a:ctx.bufnr)
  let l:striplen = strlen(l:bufname) - winwidth(a:ctx.winnr) + 3

  if l:striplen > 0
    let l:parts = split(strpart(l:bufname, 11), '/')
    let l:n = 0
    while l:n < l:striplen && len(l:parts) > 0
      let l:p = remove(l:parts, 0)
      let l:n += 1 + strlen(l:p)
    endwhile

    if len(l:parts) == 0
      let l:stat = ' ⋯/' . l:p
    else
      let l:stat = printf(' %s⋯/%s', l:bufname[:10], join(l:parts, '/'))
    endif
  else
    let l:stat = ' ' . l:bufname
  endif

  return a:ctx.color_alt(l:stat, ['SLHighlight', 'Statusline'])
endfunction

" }}}1

function! s:ft_tex(ctx) abort " {{{1
  let l:vimtex = getbufvar(a:ctx.bufnr, 'vimtex')
  let l:status = exists('l:vimtex.compiler.status')
        \ ? l:vimtex.compiler.status + 1
        \ : -1

  let [l:symbol, l:color] = get([
        \ ['[⏻] ', ''],
        \ ['[⏻] ', ''],
        \ ['[⟳] ', ''],
        \ ['[✔︎] ', 'SLSuccess'],
        \ ['[✖] ', 'SLAlert']
        \], l:status)

  return s:fallback(a:ctx) . a:ctx.color(l:symbol, l:color)
endfunction

" }}}1
function! s:ft_wiki(ctx) abort " {{{1
  let l:stat = a:ctx.info(' wiki: ')
  let l:stat .= a:ctx.hlight(fnamemodify(bufname(a:ctx.bufnr), ':t:r'))

  if get(get(b:, 'wiki', {}), 'in_diary', 0)
    let l:stat .= a:ctx.alert(' (diary)')
  endif

  if !getbufvar(a:ctx.bufnr, '&modifiable')
    let l:stat .= a:ctx.alert(' [Locked]')
  endif
  if getbufvar(a:ctx.bufnr, '&readonly')
    let l:stat .= a:ctx.alert(' [‼]')
  endif
  if getbufvar(a:ctx.bufnr, '&modified')
    let l:stat .= a:ctx.alert(' [+]')
  endif

  let l:file = fnamemodify(bufname(a:ctx.bufnr), ':p')
  if filereadable(l:file)
    let l:graph = wiki#graph#builder#get()
    let l:broken_links = l:graph.get_broken_links_from(l:file)
    if len(l:broken_links) > 0
      let l:stat .= a:ctx.alert(printf(' (🔗%d)',len(l:broken_links)))
    endif
  endif

  return l:stat
endfunction

" }}}1
function! s:ft_man(ctx) abort " {{{1
  return a:ctx.hlight(' %<%f')
endfunction

" }}}1

function! s:fallback(ctx) abort " {{{1
  let l:stat = a:ctx.hlight(' %<%f')

  if !getbufvar(a:ctx.bufnr, '&modifiable')
    let l:stat .= a:ctx.alert(' [Locked]')
  endif
  if getbufvar(a:ctx.bufnr, '&readonly')
    let l:stat .= a:ctx.alert(' [‼]')
  endif
  if getbufvar(a:ctx.bufnr, '&modified')
    let l:stat .= a:ctx.alert(' [+]')
  endif

  " Add status message from dap.nvim
  try
    let l:dap = luaeval('require "dap".status()')
    if !empty(l:dap)
      let l:stat .= '%=' . a:ctx.color('[dap: ' . l:dap . ']', 'DapStatus')
    endif
  catch /E5108/
  endtry

  " Change to right-hand side
  let l:stat .= '%='

  " Add status message from nvim-metals
  if exists('g:metals_status') && !empty(g:metals_status)
    let l:stat .= a:ctx.color(' ' . g:metals_status, 'MetalsStatus')
  endif

  " Previewwindows don't need more details
  if getwinvar(a:ctx.winnr, '&previewwindow')
    return l:stat . a:ctx.alert(' [preview] ')
  endif

  " Add column number if above textwidth
  let cn = virtcol('$') - 1
  if &textwidth > 0 && cn > &textwidth
    let l:stat .= a:ctx.alert(printf(' [%s > %s &tw]', cn, &textwidth))
  endif

  try
    let l:head = FugitiveHead(12)
    if !empty(l:head)
      let l:stat .= ' ⑂' . l:head
    endif
  catch
  endtry

  return l:stat . ' '
endfunction

" }}}1


let s:ctx = {
      \ 'active': v:false,
      \}

function! s:ctx.alert(content) dict abort " {{{1
  return self.active
        \ ? '%#SLAlert#' . a:content . '%*'
        \ : a:content
endfunction

" }}}1
function! s:ctx.info(content) dict abort " {{{1
  return self.active
        \ ? '%#SLInfo#' . a:content . '%*'
        \ : a:content
endfunction

" }}}1
function! s:ctx.hlight(content) dict abort " {{{1
  return self.active
        \ ? '%#SLHighlight#' . a:content . '%*'
        \ : a:content
endfunction

" }}}1
function! s:ctx.color(content, group) dict abort " {{{1
  return self.active && !empty(a:group)
        \ ? '%#' . a:group . '#' . a:content . '%*'
        \ : a:content
endfunction

" }}}1
function! s:ctx.color_alt(content, groups) dict abort " {{{1
  return '%#' . a:groups[!self.active] . '#' . a:content . '%*'
endfunction

" }}}1
