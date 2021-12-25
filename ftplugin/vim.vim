if exists('b:did_ftplugin_personal') | finish | endif
let b:did_ftplugin_personal = 1

if exists('ruby_fold') | unlet ruby_fold | endif

set foldmethod=marker
let g:vimsyn_folding = 'f'

" Mappings for working with plugins and vimscript files
nnoremap         <buffer> <leader>xx :Runtime %<cr>
xnoremap <silent><buffer> <leader>xx "vy:@v<cr>
