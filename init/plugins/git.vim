let g:flog_default_arguments = {}
let g:flog_default_arguments.format = '[%h] %s%d'
let g:flog_default_arguments.date = 'format:%Y-%m-%d %H:%M:%S'

nnoremap <silent><leader>gl :silent Flog -all<cr>
nnoremap <silent><leader>gL :silent Flog -all -path=%<cr>

augroup init_flog
  autocmd!
  autocmd FileType floggraph setlocal nolist
  autocmd FileType floggraph nmap <buffer><silent> q <plug>(FlogQuit)
  autocmd FileType floggraph nmap <buffer><silent> <f5> <plug>(FlogUpdate)
  autocmd FileType floggraph nnoremap <buffer><silent> p
        \ :<c-u>call personal#git#display_file_current()<cr>
  autocmd FileType floggraph nnoremap <buffer><silent> <tab>
        \ :<c-u>call personal#git#display_file()<cr>
  autocmd FileType floggraph nnoremap <buffer><silent> df
        \ :<c-u>call personal#git#diff_file()<cr>
augroup END

nnoremap <silent><leader>gs :call personal#git#fugitive_toggle()<cr>
nnoremap <silent><leader>ge :Gedit<cr>
nnoremap <silent><leader>gd :Gdiff<cr>:WinResize<cr>
nnoremap <silent><leader>gb :GBrowse<cr>
xnoremap <silent><leader>gb :GBrowse<cr>
nnoremap <silent><leader>gB :Telescope git_branches<cr>

augroup init_fugitive
  autocmd!
  autocmd WinEnter index call fugitive#ReloadStatus(-1, 0)
  autocmd BufReadPost fugitive:// setlocal bufhidden=delete

  " Fugitive Status buffer
  autocmd FileType fugitive nnoremap <buffer><silent> q :bwipeout!<cr>
  autocmd FileType fugitive
        \ nnoremap <buffer><silent> <f5> :call fugitive#ReloadStatus(-1, 0)<cr>
augroup END

" I only want GBrowse functionality from rhubarb
let g:loaded_rhubarb = 1
let g:fugitive_browse_handlers = [function('rhubarb#FugitiveUrl')]
