if exists('b:did_ftplugin_personal') | finish | endif
let b:did_ftplugin_personal = 1

setlocal nolist
setlocal foldmethod=syntax
setlocal foldlevel=0

nnoremap <buffer><silent> q :bwipeout!<cr>
