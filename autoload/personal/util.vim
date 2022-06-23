function! personal#util#copy_path() abort " {{{1
  let l:file = expand('%:p')
  if empty(l:file) | return | endif

  " Use Rooter to find root path
  let l:root = FindRootDirectory()
  if !empty(l:root)
    let l:file = vimtex#paths#relative(l:file, l:root)
  endif
  if empty(l:file) | return | endif

  let l:path = l:file . ':' . line('.')
  let @* = l:path
  let @+ = l:path
  call v:lua.vim.notify('Copied path: ' . l:path)
endfunction

" }}}1
