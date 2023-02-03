setlocal nolist
nmap <buffer><silent> q <plug>(FlogQuit)
nmap <buffer><silent> <f5> <plug>(FlogUpdate)
nnoremap <buffer><silent> p <cmd>call personal#git#display_file_current()<cr>
nnoremap <buffer><silent> <tab> <cmd>call personal#git#display_file()<cr>
nnoremap <buffer><silent> df <cmd>call personal#git#diff_file()<cr>
