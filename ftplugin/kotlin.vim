if exists('b:did_ftplugin_personal') | finish | endif
let b:did_ftplugin_personal = 1

setlocal formatoptions-=t
setlocal comments=O://
let &l:commentstring = '// %s'

" Rely on Treesitter for folding
setlocal foldmethod=expr
setlocal foldexpr=nvim_treesitter#foldexpr()
