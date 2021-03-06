if exists('b:did_ftplugin_personal') | finish | endif
let b:did_ftplugin_personal = 1

setlocal includeexpr=substitute(v:fname,'\\.','/','g')
setlocal suffixesadd=.kt

setlocal formatoptions-=t
setlocal comments=sO:*\ -,mO:*\ \ ,exO:*/,s1:/*,mb:*,ex:*/,://
setlocal commentstring=//\ %s

" Rely on Treesitter for folding
setlocal foldmethod=expr
setlocal foldexpr=nvim_treesitter#foldexpr()

" Configure indentation
setlocal cinoptions+=j1,)100
setlocal indentkeys=0},0),!^F,o,O,e,<cr>
setlocal indentexpr=personal#kotlin#indentexpr()
