let g:loaded_fastfold = 1
if exists('g:loaded_fastfold') | finish | endif

function! s:leave_win() abort
  if exists('w:ff_prediff_fdm')
    if empty(&l:foldmethod) || &l:foldmethod is# 'manual'
      let &l:foldmethod = w:ff_prediff_fdm
      unlet w:ff_prediff_fdm
      return
    endif

    if &l:foldmethod isnot# 'diff'
      unlet w:ff_prediff_fdm
    endif
  endif

  if exists('w:ff_lastfdm') && &l:foldmethod is# 'diff'
    let w:ff_prediff_fdm = w:ff_lastfdm
  endif

  if exists('w:ff_lastfdm') && &l:foldmethod is# 'manual'
    let &l:foldmethod = w:ff_lastfdm
  endif
endfunction

function! s:enter_win() abort
  if line('$') <= 100
        \ || (&l:foldmethod isnot# 'syntax' && &l:foldmethod isnot# 'expr')
        \ || !empty(&l:buftype)
        \ || !&l:modifiable
    unlet! w:ff_lastfdm
    return
  endif

  let w:ff_lastfdm = &l:foldmethod
  setlocal foldmethod=manual
endfunction

function! s:windo(cmd) abort
  if !empty(getcmdwintype()) | return | endif

  let l:currwinwidth = &winwidth
  let &winwidth = 1

  let l:curaltwin = winnr('#') ? winnr('#') : 1
  let l:currwin = winnr()
  silent! execute 'keepjumps noautocmd windo ' . a:cmd
  silent! execute 'noautocmd ' . l:curaltwin . 'wincmd w'
  silent! execute 'noautocmd ' . l:currwin . 'wincmd w'

  let &winwidth = l:currwinwidth
endfunction

function! s:update_win() abort
  let s:curwin = winnr()
  call s:windo('if winnr() is s:curwin | call s:leave_win() | endif')
  call s:windo('if winnr() is s:curwin | call s:enter_win() | endif')
endfunction

function! s:update_buf() abort
  let s:curbuf = bufnr('%')
  call s:windo("if bufnr('%') is s:curbuf | call s:leave_win() | endif")
  call s:windo("if bufnr('%') is s:curbuf | call s:enter_win() | endif")
endfunction

function! s:sync_winenter() abort
  let w:ff_winenterbuf = bufnr('%')
  if exists('b:ff_lastfdm')
    let w:ff_lastfdm = b:ff_lastfdm
  endif
endfunction

function! s:sync_winleave() abort
  if exists('w:ff_lastfdm')
    let b:ff_lastfdm = w:ff_lastfdm
  elseif exists('b:ff_lastfdm')
    unlet b:ff_lastfdm
  endif

  if exists('w:ff_prediff_fdm')
    let b:ff_prediff_fdm = w:ff_prediff_fdm
  elseif exists('b:ff_prediff_fdm')
    unlet b:ff_prediff_fdm
  endif
endfunction

function! s:sync_bufenter() abort
  if exists('w:ff_winenterbuf')
    if w:ff_winenterbuf != bufnr('%')
      unlet! w:ff_lastfdm
    endif
    unlet w:ff_winenterbuf
  endif

  if !exists('b:ff_lastchangedtick')
    let b:ff_lastchangedtick = b:changedtick
  elseif b:changedtick != b:ff_lastchangedtick
        \ && &l:foldmethod isnot# 'diff'
        \ && exists('b:ff_prediff_fdm')
    " Update folds after entering a changed buffer
    call s:update_buf()
  endif
endfunction

function! s:sync_bufleave() abort
  let b:ff_lastchangedtick = b:changedtick
endfunction

function! s:init() abort
  call s:windo('call s:leave_win()')
  call s:windo('call s:enter_win()')

  augroup FastFoldEnter
    autocmd!
    autocmd WinEnter * call s:sync_winenter()
    autocmd WinLeave * call s:sync_winleave()
    autocmd BufEnter * call s:sync_bufenter()
    autocmd BufLeave * call s:sync_bufleave()

    autocmd FileType           * call s:update_buf()
    autocmd OptionSet foldmethod call s:update_buf()
    autocmd BufRead            * call s:update_buf()
    autocmd BufWritePost       * call s:update_buf()
    " autocmd BufWinEnter        *
    "       \ if !exists('b:ff_update_ini') |
    "       \   call s:update_buf('BufWinEnter') |
    "       \   let b:ff_update_ini = 1 |
    "       \ endif
  augroup END
endfunction

augroup FastFold
  autocmd!
  autocmd VimEnter * call s:init()
augroup end

nnoremap <silent> zx :<c-u>call <sid>update_win()<cr>zx
nnoremap <silent> zX :<c-u>call <sid>update_win()<cr>zX

" vim: fdm=syntax
