let g:fzf_layout = {'window': {'width': 0.9, 'height': 0.85}}
let g:fzf_colors = {
      \ 'fg':      ['fg', 'Normal'],
      \ 'bg':      ['bg', 'Normal'],
      \ 'hl':      ['fg', 'Comment'],
      \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
      \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
      \ 'hl+':     ['fg', 'Statement'],
      \ 'info':    ['fg', 'PreProc'],
      \ 'border':  ['fg', 'Ignore'],
      \ 'prompt':  ['fg', 'Conditional'],
      \ 'pointer': ['fg', 'Exception'],
      \ 'marker':  ['fg', 'Keyword'],
      \ 'spinner': ['fg', 'Label'],
      \ 'header':  ['fg', 'Comment'],
      \}
let g:fzf_preview_window = ''

let g:fzf_mru_no_sort = 1
let g:fzf_mru_max = 1000
let g:fzf_mru_exclude = '\v' . join([
      \ '\.git/',
      \ '\.local/wiki',
      \ '\.cache/',
      \ '^/tmp/',
      \], '|')

command! -bang Zotero call fzf#run(fzf#wrap(
            \ 'zotero',
            \ { 'source':  'fd -t f -e pdf . ~/.local/zotero/',
            \   'sink':    {x -> system(['zathura', '--fork', x])},
            \   'options': '-m -d / --with-nth=-1' },
            \ <bang>0))

nnoremap <silent> <leader>om       :FZFFreshMru --prompt "History > "<cr>
" nnoremap <silent> <leader>ow       :WikiFzfPages<cr>
nnoremap <silent> <leader>oz       :Zotero<cr>

augroup init_fzf
  autocmd!
  autocmd User FzfStatusLine call s:nothing()
  autocmd FileType fzf silent! tunmap <esc>
augroup END

function! s:nothing()
endfunction
