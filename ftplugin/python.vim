" Only load file once
if exists('b:did_ftplugin_personal') | finish | endif
let b:did_ftplugin_personal = 1

setlocal define=^\s*\\(def\\\\|class\\)
setlocal colorcolumn=80
setlocal foldexpr=personal#python#foldexpr(v:lnum)
setlocal foldmethod=expr

call personal#python#set_path()
