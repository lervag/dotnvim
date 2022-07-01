if exists('b:did_ftplugin_personal') | finish | endif
let b:did_ftplugin_personal = 1

setlocal nohlsearch
setlocal fo-=n
setlocal signcolumn=no
setlocal foldmethod=expr
let &l:foldexpr = "getline(v:lnum) =~# '^\\d' ? '>1' : '1'"

nnoremap <buffer><silent> ,t /\C\%18c \?x<cr>
nnoremap <buffer><silent> ,n Gonew<c-r>=UltiSnips#ExpandSnippet()<cr>
nmap     <buffer><silent> ,a zRgg/^2006-<cr>?^200<cr>k2yy}Pj$<c-a>oadd

autocmd BufEnter dagbok.txt ++once silent! normal {,tlzv
