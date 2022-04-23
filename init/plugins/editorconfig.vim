let g:EditorConfig_exclude_patterns = ['fugitive://.*']

augroup init_editorconfig
  autocmd!
  autocmd FileType gitcommit let b:EditorConfig_disable = 1
augroup END
