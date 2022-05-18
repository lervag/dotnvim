"
" Statusline functions
"
" Inspiration:
" - https://github.com/blaenk/dots/blob/master/vim/.vimrc
" - http://www.blaenkdenum.com/posts/a-simpler-vim-statusline/
"

function! personal#statusline#refresh() " {{{1
  for nr in range(1, winnr('$'))
    if !s:ignored(nr)
      call setwinvar(nr, '&statusline', '%!personal#statusline#main(' . nr . ')')
    endif
  endfor
endfunction

"}}}1
function! personal#statusline#main(winnr) " {{{1
  let l:winnr = winbufnr(a:winnr) == -1 ? 1 : a:winnr
  let l:active = l:winnr == winnr()
  let l:bufnr = winbufnr(l:winnr)
  let l:buftype = getbufvar(l:bufnr, '&buftype')
  let l:filetype = getbufvar(l:bufnr, '&filetype')
  let l:bufname_special = matchstr(bufname(l:bufnr), '^\w\+\ze:\/\/')

  " Try to call buffer type specific functions
  try
    return s:bt_{l:buftype}(l:bufnr, l:active, l:winnr)
  catch /E117: Unknown function/
  endtry

  " Handle "special" buffers
  if !empty(l:bufname_special)
    try
      return s:scheme_{l:bufname_special}(l:bufnr, l:active, l:winnr)
    catch /E117: Unknown function/
    endtry
  endif

  " Try to call filetype specific functions
  try
    return s:ft_{l:filetype}(l:bufnr, l:active, l:winnr)
  catch /E117: Unknown function/
  endtry

  return s:main(l:bufnr, l:active, l:winnr)
endfunction

" }}}1

function! s:main(bufnr, active, winnr) " {{{1
  let stat  = s:color(' %<%f', 'SLHighlight', a:active)
  let stat .= getbufvar(a:bufnr, '&modifiable')
        \ ? '' : s:color(' [Locked]', 'SLAlert', a:active)
  let stat .= getbufvar(a:bufnr, '&readonly')
        \ ? s:color(' [‼]', 'SLAlert', a:active) : ''
  let stat .= getbufvar(a:bufnr, '&modified')
        \ ? s:color(' [+]', 'SLAlert', a:active) : ''

  " Add status message from dap.nvim
  try
    let l:dap = luaeval('require "dap".status()')
    if !empty(l:dap)
      let stat .= '%=' . s:color('[dap: ' . l:dap . ']', 'DapStatus', a:active)
    endif
  catch /E5108/
  endtry

  " Change to right-hand side
  let stat .= '%='

  " Add status message from nvim-metals
  if exists('g:metals_status') && !empty(g:metals_status)
    let stat .= s:color(' ' . g:metals_status, 'MetalsStatus', a:active)
  endif

  " Add LSP status
  if luaeval('#vim.lsp.buf_get_clients() > 0')
    let stat .= s:lsp_status(a:active)
  endif

  " Previewwindows don't need more details
  set noautochdir
  let l:preview = getwinvar(a:winnr, '&previewwindow')
  set autochdir
  if l:preview
    let stat .= s:color(' [preview]', 'SLAlert', a:active) . ' '
    return stat
  endif

  " Add column number if above textwidth
  let cn = virtcol('$') - 1
  if &textwidth > 0 && cn > &textwidth
    let stat .= s:color(
          \ printf(' [%s > %s &tw]', cn, &textwidth), 'SLAlert', a:active)
  endif

  try
    let l:head = FugitiveHead(12)
    if !empty(l:head)
      let stat .= ' ⑂' . l:head
    endif
  catch
  endtry

  let stat .= ' '

  return stat
endfunction

" }}}1


function! s:bt_help(bufnr, active, winnr) " {{{1
  return s:color(
        \ ' vimdoc: ' . fnamemodify(bufname(a:bufnr), ':t:r'),
        \ 'SLInfo', a:active)
endfunction

" }}}1
function! s:bt_quickfix(bufnr, active, winnr) " {{{1
  let l:nr = personal#qf#get_prop({
        \ 'winnr': a:winnr,
        \ 'key': 'nr',
        \})
  let l:last = personal#qf#get_prop({
        \ 'winnr': a:winnr,
        \ 'key': 'nr',
        \ 'val': '$',
        \})

  let text = ' ['
  let text .= personal#qf#is_loc(a:winnr) ? 'Loclist' : 'Quickfix'
  if l:last > 1
    let text .= ' ' . l:nr . '/' . l:last
  endif

  let text .= '] (' . personal#qf#length(a:winnr) . ') '

  let text .= personal#qf#get_prop({
        \ 'winnr': a:winnr,
        \ 'key': 'title',
        \})
  let stat  = s:color(text, 'SLHighlight', a:active)

  return stat
endfunction

" }}}1

function! s:ft_tex(bufnr, active, winnr) " {{{1
  let l:vimtex = getbufvar(a:bufnr, 'vimtex')
  let l:status = exists('l:vimtex.compiler.status')
        \ ? l:vimtex.compiler.status + 1
        \ : -1

  let [l:symbol, l:color] = get([
        \ ['[⏻] ', ''],
        \ ['[⏻] ', ''],
        \ ['[⟳] ', ''],
        \ ['[✔︎] ', 'SLInfo'],
        \ ['[✖] ', 'SLAlert']
        \], l:status)

  return s:main(a:bufnr, a:active, a:winnr)
        \ . s:color(l:symbol, l:color, a:active)
endfunction

" }}}1
function! s:ft_wiki(bufnr, active, winnr) " {{{1
  let stat  = s:color(' wiki: ', 'SLAlert', a:active)
  let stat .= s:color(fnamemodify(bufname(a:bufnr), ':t:r'),
        \ 'SLHighlight', a:active)
  if get(get(b:, 'wiki', {}), 'in_diary', 0)
    let stat .= s:color(' (diary)', 'SLAlert', a:active)
  endif

  let stat .= getbufvar(a:bufnr, '&modifiable')
        \ ? '' : s:color(' [Locked]', 'SLAlert', a:active)
  let stat .= getbufvar(a:bufnr, '&readonly')
        \ ? s:color(' [‼]', 'SLAlert', a:active) : ''
  let stat .= getbufvar(a:bufnr, '&modified')
        \ ? s:color(' [+]', 'SLAlert', a:active) : ''
  return stat
endfunction

" }}}1
function! s:ft_fzf(bufnr, active, winnr) " {{{1
  return s:color(repeat('⋯', winwidth(a:winnr)), 'SLFZF', a:active)
endfunction

" }}}1
function! s:ft_manpage(bufnr, active, winnr) " {{{1
  return s:color(' %<%f', 'SLHighlight', a:active)
endfunction

" }}}1

function! s:scheme_fugitive(bufnr, active, winnr) " {{{1
  let l:bufname = bufname(a:bufnr)
  let l:striplen = strlen(l:bufname) - winwidth(a:winnr) + 3

  if l:striplen > 0
    let l:parts = split(strpart(l:bufname, 11), '/')
    let l:n = 0
    while l:n < l:striplen && len(l:parts) > 0
      let l:p = remove(l:parts, 0)
      let l:n += 1 + strlen(l:p)
    endwhile

    if len(l:parts) == 0
      let l:string = ' ⋯/' . l:p
    else
      let l:string = printf(' %s⋯/%s', l:bufname[:10], join(l:parts, '/'))
    endif
  else
    let l:string = ' ' . l:bufname
  endif

  return s:color(l:string, ['SLHighlight', 'Statusline'], a:active)
endfunction

" }}}1
function! s:scheme_vimspector(bufnr, active, winnr) " {{{1
  return s:color(
        \ substitute(bufname(a:bufnr), '^vimspector.', 'Vimspector: ', ''),
        \ 'SLHighlight', a:active)
endfunction

" }}}1


function! s:lsp_status(active) abort " {{{1
  let l:symbol = '⯒'
  try
    let msg = get(luaeval('require("lsp-status").messages()'), 0, {})
    " Three kinds of messages:
    " {
    "   name = Server name,
    "   title = Progress item title,
    "   message = Current progress message (if any),
    "   percentage = Current progress percentage (if any),
    "   progress = true,
    "   spinner = Spinner frames index,
    " }
    "
    " {
    "   name = Server name,
    "   content = Message content,
    "   uri = File URI,
    "   status = true
    " }
    " {
    "   name = Server name,
    "   content = Message contents
    " }
    if has_key(msg, 'percentage')
      return s:color(printf('%s %s: %d %%%%',
            \ l:symbol, msg.title, msg.percentage),
            \ 'SLHighlight', a:active)
    elseif has_key(msg, 'content')
      return printf('%s %s', l:symbol, msg.content)
    endif

    let l:diagnostics = luaeval('require("lsp-status").diagnostics()')
    let l:linter = map(filter([
          \   ['E', get(l:diagnostics, 'errors')],
          \   ['W', get(l:diagnostics, 'warnings')],
          \ ], {_, x -> x[1] >= 1}), {_, x -> x[0] . x[1]})
    if empty(l:linter) | return l:symbol | endif

    let l:color = get(l:diagnostics, 'errors')
          \ ? 'SLAlert'
          \ : get(l:diagnostics, 'warnings') ? 'SLHighlight' : ''
    return s:color(l:symbol . ' ' . join(l:linter, ' '), l:color, a:active)
  catch /E5108/
    return ''
  endtry
endfunction

" }}}1


" Utilities
function! s:color(content, group, active) " {{{1
  if type(a:group) == v:t_list
    return '%#' . a:group[!a:active] . '#' . a:content . '%*'
  elseif a:active && !empty(a:group)
    return '%#' . a:group . '#' . a:content . '%*'
  endif

  return a:content
endfunction

" }}}1
function! s:ignored(winnr) " {{{1
  let l:name = bufname(winbufnr(a:winnr))

  if l:name =~# '^\%(undotree\|diffpanel\)'
    return 1
  endif

  return 0
endfunction

" }}}1
