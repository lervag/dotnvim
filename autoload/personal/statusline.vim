"
" Statusline functions
"
" Inspiration:
" - https://github.com/blaenk/dots/blob/master/vim/.vimrc
" - http://www.blaenkdenum.com/posts/a-simpler-vim-statusline/
"

function! personal#statusline#main() abort " {{{1
  let l:context = {}
  let l:context.winnr = win_id2win(g:statusline_winid)
  let l:context.bufnr = winbufnr(l:context.winnr)
  if l:context.bufnr == -1
    let l:context.winnr = 1
  endif
  let l:context.active = l:context.winnr == winnr()

  try
    let l:buftype = getbufvar(l:context.bufnr, '&buftype')
    return s:buftype_{l:buftype}(l:context)
  catch /E117: Unknown function/
  endtry

  try
    let l:match = matchstr(bufname(l:context.bufnr), '^\w\+\ze:\/\/')
    if !empty(l:match)
      return s:scheme_{l:match}(l:context)
    endif
  catch /E117: Unknown function/
  endtry

  let l:match = tolower(
        \ matchstr(bufname(l:context.bufnr),
        \          '\v_\zs%(LOCAL|REMOTE)\ze_\d+'))
  if !empty(l:match) && getwinvar(l:context.winnr, '&diff')
    return s:scheme_merge(l:context, l:match)
  endif

  try
    let l:filetype = getbufvar(l:context.bufnr, '&filetype')
    return s:filetype_{l:filetype}(l:context)
  catch /E117: Unknown function/
  endtry

  return s:main(l:context)
endfunction

" }}}1


function! s:main(context) abort " {{{1
  let l:stat = s:_highlight(a:context, ' %<%f')
  let l:stat .= s:status_common(a:context)
  let l:stat .= s:status_dap(a:context)

  " Change to right-hand side
  let l:stat .= '%='

  " Add status message from nvim-metals
  if exists('g:metals_status') && !empty(g:metals_status) && a:context.active
    let l:stat .= '%#SLInfo# ' . g:metals_status . '%*'
  endif

  " Previewwindows don't need more details
  if getwinvar(a:context.winnr, '&previewwindow')
    return l:stat . s:_alert(a:context, ' [preview] ')
  endif

  " Add column number if above textwidth
  let cn = virtcol('$') - 1
  if &textwidth > 0 && cn > &textwidth
    let l:stat .= s:_alert(a:context, printf(' [%s > %s &tw]', cn, &textwidth))
  endif

  try
    let l:head = FugitiveHead(7, a:context.bufnr)
    if !empty(l:head)
      let l:stat .= ' ⑂' . l:head
    endif
  catch
  endtry

  return l:stat . ' '
endfunction

" }}}1

function! s:buftype_help(context) abort " {{{1
  return s:_info(a:context, ' vimdoc: ')
        \ . s:_highlight(a:context,
        \     fnamemodify(bufname(a:context.bufnr), ':t:r'))
endfunction

" }}}1
function! s:buftype_nofile(context) abort " {{{1
  return s:_info(a:context, ' %f') . '%= %l av %L '
endfunction

" }}}1
function! s:buftype_prompt(context) abort " {{{1
  return s:_info(a:context, ' %f') . '%= %l/%L '
endfunction

" }}}1
function! s:buftype_quickfix(context) abort " {{{1
  let l:stat = ' ['
  let l:stat .= personal#qf#is_loc(a:context.winnr) ? 'Loclist' : 'Quickfix'
  let l:qf_last = personal#qf#get_prop('nr', '$', a:context.winnr)
  if l:qf_last > 1
    let l:qf_nr = personal#qf#get_prop('nr', 0, a:context.winnr)
    let l:stat .= ' ' . l:qf_nr . '/' . l:qf_last
  endif

  let l:stat .= '] (' . personal#qf#length(a:context.winnr) . ') '

  let l:stat .= personal#qf#get_prop('title', 0, a:context.winnr)

  return s:_highlight(a:context, l:stat)
endfunction

" }}}1

function! s:scheme_fugitive(context) abort " {{{1
  let l:bufname = bufname(a:context.bufnr)

  let l:fname = matchstr(l:bufname, '\.git\/\/\x*\/\zs.*')
  if empty(l:fname)
    let l:fname = matchstr(l:bufname, '\.git\/\/\zs\x*')
  endif

  if empty(l:fname)
    return s:_info(a:context, ' fugitive: ')
          \ . s:_highlight(a:context, 'Git status')
  endif

  let l:stat = s:_info(a:context, ' fugitive: %<')
  let l:stat .= s:_highlight(a:context, l:fname)
  let l:stat .= s:status_common(a:context)

  let l:commit = matchstr(l:bufname, '\.git\/\/\zs\x\{7}')
  let l:stat .= '%= ⑂' . (empty(l:commit) ? 'HEAD' : l:commit) . ' '

  return l:stat
endfunction

" }}}1
function! s:scheme_diffview(context) abort " {{{1
  let l:bufname = bufname(a:context.bufnr)

  let l:fname = matchstr(l:bufname, '\.git\/[0-9a-z:]*\/\zs.*')
  if empty(l:fname)
    let l:fname = matchstr(l:bufname, '\.git\/\zs[0-9a-z:]*')
  endif

  if empty(l:fname)
    let l:name = matchstr(l:bufname, 'panels\/\d\+\/\zs.*')
    return s:_info(a:context, ' diffview: ') . s:_highlight(a:context, l:name)
  endif

  let l:stat = s:_info(a:context, ' diffview: %<')
  let l:stat .= s:_highlight(a:context, l:fname)
  let l:stat .= s:status_common(a:context)

  let l:commit = matchstr(l:bufname, '\.git\/\zs[0-9a-z:]\{7}')
  let l:stat .= '%= ⑂' . (empty(l:commit) ? 'HEAD' : l:commit) . ' '

  return l:stat
endfunction

" }}}1
function! s:scheme_merge(context, version) abort " {{{1
  let l:mm = getwinvar(a:context.winnr, '__merge_mode', {})
  if !empty(l:mm)
    let l:version = l:mm.version ==# 'mine' ? 'LOCAL' : 'REMOTE'
  else
    let l:version = a:version
  endif

  return s:_c2(a:context,
        \ ' Merge conflict: ' . l:version,
        \ ['SLHighlight', 'SLInfo'])
endfunction

" }}}1

function! s:filetype_tex(context) abort " {{{1
  let l:vimtex = getbufvar(a:context.bufnr, 'vimtex')
  let l:status = exists('l:vimtex.compiler.status')
        \ ? l:vimtex.compiler.status + 1
        \ : -1

  let [l:symbol, l:color] = get([
        \ ['[⏻] ', ''],
        \ ['[⏻] ', ''],
        \ ['[⟳] ', ''],
        \ ['[✔︎] ', 'success'],
        \ ['[✖] ', 'alert']
        \], l:status)

  if !empty(l:color)
    let l:symbol = s:_{l:color}(a:context, l:symbol)
  endif

  return s:main(a:context) . l:symbol
endfunction

" }}}1
function! s:filetype_wiki(context) abort " {{{1
  let l:fname = fnamemodify(bufname(a:context.bufnr), ':t:r')
  let l:stat = s:_info(a:context, ' wiki: ')
  let l:stat .= s:_highlight(a:context, l:fname)

  if get(get(b:, 'wiki', {}), 'in_journal', 0)
    let l:stat .= s:_info(a:context, '  ')
  endif

  let l:stat .= s:status_common(a:context)

  let l:file = fnamemodify(bufname(a:context.bufnr), ':p')
  if filereadable(l:file)
    let l:graph = wiki#graph#builder#get()
    let l:broken_links = l:graph.get_broken_links_from(l:file)
    if len(l:broken_links) > 0
      let l:stat .= s:_alert(a:context, printf(' (🔗%d)',len(l:broken_links)))
    endif
  endif

  return l:stat
endfunction

" }}}1
function! s:filetype_man(context) abort " {{{1
  return s:_highlight(a:context, ' %<%f')
endfunction

" }}}1

function! s:status_common(context) abort " {{{1
  let l:stat = ''

  try
    let l:mode = luaeval('require("noice").api.statusline.mode.has()')
          \ ? luaeval('require("noice").api.statusline.mode.get()')
          \ : ''
    if !empty(l:mode)
      let l:mode = substitute(l:mode, '^recording @', '●', '')
      let l:stat .= s:_success(a:context, l:mode) . ' '
    endif
  catch
  endtry

  let l:locked = !getbufvar(a:context.bufnr, '&modifiable')
        \ || getbufvar(a:context.bufnr, '&readonly')
  if l:locked
    let l:stat .= s:_alert(a:context, ' ')
  endif
  if getbufvar(a:context.bufnr, '&modified')
    let l:stat .= s:_info(a:context, ' ')
  endif

  if !l:locked
    for l:cfg in [
          \ #{ severity: 'ERROR', method: 'alert',     symbol: ''},
          \ #{ severity: 'WARN',  method: 'highlight', symbol: ''},
          \ #{ severity: 'INFO',  method: 'info',      symbol: ''},
          \]
      let l:n = luaeval(printf(
            \ '#vim.diagnostic.get(%d, {severity = vim.diagnostic.severity.%s})',
            \ a:context.bufnr,
            \ l:cfg.severity))
      if l:n > 0
        let l:stat .= s:_{l:cfg.method}(a:context, printf(' %s %d', l:cfg.symbol, l:n))
      endif
    endfor
  endif

  return empty(l:stat) ? '' : ' ' . l:stat
endfunction

" }}}1
function! s:status_dap(context) abort " {{{1
  try
    let l:dap = luaeval('require "dap".status()')
    return empty(l:dap)
          \ ? ''
          \ : '%=' . s:_c1(a:context, '[dap: ' . l:dap . ']', 'DapStatus')
  catch /E5108/
    return ''
  endtry
endfunction

" }}}1

function! s:_info(context, text) abort " {{{1
  return a:context.active ? '%#SLInfo#' . a:text . '%*' : a:text
endfunction

" }}}1
function! s:_alert(context, text) abort " {{{1
  return a:context.active ? '%#SLAlert#' . a:text . '%*' : a:text
endfunction

" }}}1
function! s:_success(context, text) abort " {{{1
  return a:context.active ? '%#SLSuccess#' . a:text . '%*' : a:text
endfunction

" }}}1
function! s:_highlight(context, text) abort " {{{1
  return a:context.active ? '%#SLHighlight#' . a:text . '%*' : a:text
endfunction

" }}}1

function! s:_c1(context, text, group) abort " {{{1
  return a:context.active ? '%#' . a:group . '#' . a:text . '%*' : a:text
endfunction

" }}}1
function! s:_c2(context, text, groups) abort " {{{1
  return '%#' . a:groups[!a:context.active] . '#' . a:text . '%*'
endfunction

" }}}1
