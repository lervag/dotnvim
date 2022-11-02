xnoremap <leader>ed :Linediff<cr>
nmap <leader>ed <plug>(linediff-operator)

augroup init_linediff
  autocmd!
  autocmd User LinediffBufferReady
        \ nnoremap <buffer> <leader>eq :LinediffReset<cr>
augroup END
