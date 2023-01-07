let g:wiki_root = '~/.local/wiki'
let g:wiki_toc_title = 'Innhald'
let g:wiki_viewer = {'_': 'sioyek'}
let g:wiki_export = {
      \ 'output': 'printed',
      \}
let g:wiki_filetypes = ['wiki', 'md']
let g:wiki_mappings_local = {
      \ '<plug>(wiki-link-toggle-operator)' : 'gL',
      \}
let g:wiki_month_names = [
      \ 'Januar',
      \ 'Februar',
      \ 'Mars',
      \ 'April',
      \ 'Mai',
      \ 'Juni',
      \ 'Juli',
      \ 'August',
      \ 'September',
      \ 'Oktober',
      \ 'November',
      \ 'Desember'
      \]
let g:wiki_template_title_week = '# Samandrag veke %(week), %(year)'
let g:wiki_template_title_month = '# Samandrag frå %(month-name) %(year)'
let g:wiki_write_on_nav = 1

let g:wiki_toc_depth = 2
let g:wiki_file_handler = 'personal#wiki#file_handler'

let g:wiki_templates = [
      \ { 'match_func': {
      \     x -> x.path =~# '\.wiki$' && x.path !~# 'journal\/'},
      \   'source_func': function('personal#wiki#template')},
      \]

augroup init_wiki
  autocmd!
  autocmd User WikiLinkFollowed normal! zz
  autocmd User WikiBufferInitialized
        \ nmap <buffer> gf <plug>(wiki-link-follow)
augroup END
