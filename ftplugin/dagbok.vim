if exists('b:did_ftplugin_personal') | finish | endif
let b:did_ftplugin_personal = 1

setlocal nohlsearch
setlocal foldmethod=expr
setlocal foldexpr=personal#dagbok#foldlevel(v:lnum)
setlocal fo-=n

nnoremap <buffer><silent> ,t /\C\%18c \?x<cr>
nnoremap <buffer><silent> ,n Gonew<c-r>=UltiSnips#ExpandSnippet()<cr>
nmap     <buffer><silent> ,a zRgg/^2006-<cr>?^200<cr>k2yy}Pj$<c-a>oadd
nnoremap <buffer><silent> ,v :silent !xdg-open https://docs.google.com/spreadsheets/d/1s8OIUtS7xa_8tECA7RNpARiRyy5SWnOc4U5pFYZOEyQ/edit\#gid=0<cr>

augroup dagbok
  autocmd!
  autocmd! BufEnter dagbok.txt call personal#dagbok#init()
augroup END
