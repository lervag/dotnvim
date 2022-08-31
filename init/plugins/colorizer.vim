let g:colorizer_auto_filetype = 'css,html'
let g:colorizer_colornames = 0

augroup init_colorizer
  autocmd!
  autocmd BufRead my_solarized_lua.lua ColorHighlight
augroup END
