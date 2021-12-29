let g:VimuxOrientation = 'h'
let g:VimuxHeight = '50'
let g:VimuxResetSequence = ''

" Open and manage panes/runners
nnoremap <leader>io :call VimuxOpenRunner()<cr>
nnoremap <leader>iq :VimuxCloseRunner<cr>
nnoremap <leader>ip :VimuxPromptCommand<cr>
nnoremap <leader>in :VimuxInspectRunner<cr>

" Send commands
nnoremap <leader>ii  :VimuxRunCommand 'jkk'<cr>
nnoremap <leader>is  :set opfunc=personal#vimux#operator<cr>g@
nnoremap <leader>iss :call VimuxRunCommand(getline('.'))<cr>
xnoremap <leader>is  "vy :call VimuxSendText(@v)<cr>
