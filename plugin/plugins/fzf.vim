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

nnoremap <silent> <leader><leader> :FZFFreshMru --prompt "History > "<cr>
nnoremap <silent> <leader>ob       :Buffers<cr>
nnoremap <silent> <leader>ot       :Tags<cr>
nnoremap <silent> <leader>ow       :WikiFzfPages<cr>
nnoremap <silent> <leader>oz       :Zotero<cr>
nnoremap <silent> <leader>oo       :call MyFiles()<cr>
nnoremap <silent> <leader>op       :call MyFiles('~/.local/plugged')<cr>
nnoremap <silent> <leader>ov       :call fzf#run(fzf#wrap({
      \ 'dir': '~/.config/nvim',
      \ 'source': 'git ls-files --exclude-standard --others --cached',
      \ 'options': [
      \   '--prompt', 'Files ~/.config/nvim::',
      \ ],
      \}))<cr>

augroup init_fzf
  autocmd!
  autocmd User FzfStatusLine call s:nothing()
  autocmd FileType fzf silent! tunmap <esc>
augroup END

function! s:nothing()
endfunction

function! MyFiles(...) abort
  let l:dir = a:0 > 0 ? a:1 : FindRootDirectory()
  if empty(l:dir)
    let l:dir = getcwd()
  endif
  let l:dir = substitute(fnamemodify(l:dir, ':p'), '\/$', '', '')

  let l:prompt_dir = len(l:dir) > 15 ? pathshorten(l:dir) : l:dir

  call fzf#vim#files(l:dir, {
      \ 'options': [
      \   '-m',
      \   '--prompt', 'Files ' . l:prompt_dir . '::'
      \ ],
      \})
endfunction
