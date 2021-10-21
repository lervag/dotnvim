if exists('b:did_ftplugin_personal') | finish | endif
let b:did_ftplugin_personal = 1

call personal#markdown#init()

setlocal nolisp
setlocal nomodeline
setlocal suffixesadd=.wiki
setlocal isfname-=[,]
setlocal autoindent
setlocal nosmartindent
setlocal nocindent
let &l:commentstring = '// %s'
setlocal formatoptions-=o
setlocal formatoptions+=n
let &l:formatlistpat = '\v^\s*%(\d|\l|i+)\.\s'
