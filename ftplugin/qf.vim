if exists('b:did_ftplugin_personal') | finish | endif
let b:did_ftplugin_personal = 1

setlocal nowrap
setlocal nobuflisted

command! -bar -range QDeleteLine
      \ silent call personal#qf#delete_line(<line1>, <line2>)

nnoremap <buffer><silent> q  :close<cr>

nnoremap <buffer><silent> d  :set opfunc=personal#qf#delete_line<cr>g@
nnoremap <buffer><silent> dd :QDeleteLine<cr>
xnoremap <buffer><silent> dd :QDeleteLine<cr>

nnoremap <buffer><silent> f  :silent call personal#qf#filter(1)<cr>
nnoremap <buffer><silent> F  :silent call personal#qf#filter(0)<cr>

nnoremap <buffer><silent> <left>  :call personal#qf#older()<cr>
nnoremap <buffer><silent> <right> :call personal#qf#newer()<cr>

augroup quickfix_autocmds
  autocmd!
  autocmd BufReadPost quickfix call personal#qf#adjust_height()
  autocmd BufEnter <buffer> nested if winnr('$') < 2 | q | endif
  autocmd QuitPre * nested if &filetype != 'qf' | silent! lclose | endif
augroup END
