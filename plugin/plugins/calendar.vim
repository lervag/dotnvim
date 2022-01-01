let g:calendar_first_day = 'monday'
let g:calendar_date_endian = 'big'
let g:calendar_frame = 'space'
let g:calendar_week_number = 1

nnoremap <silent> <leader>c :Calendar -position=here<cr>

" Connect to diary
augroup init_calendar
  autocmd!
  autocmd FileType calendar
        \ nnoremap <silent><buffer> <cr>
        \ :<c-u>call personal#wiki#open_diary()<cr>
  autocmd FileType calendar
        \ nnoremap <silent><buffer> <c-e> <c-^>
  autocmd FileType calendar
        \ nnoremap <silent><buffer> <c-u> :WinBufDelete<cr>
augroup END
