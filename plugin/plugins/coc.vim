let g:coc_global_extensions = [
      \ 'coc-calc',
      \ 'coc-json',
      \ 'coc-ltex',
      \ 'coc-pyright',
      \ 'coc-rust-analyzer',
      \ 'coc-sh',
      \ 'coc-snippets',
      \ 'coc-vimlsp',
      \ 'coc-vimtex',
      \ 'coc-yaml',
      \]


inoremap <silent><expr> <c-space> coc#refresh()

inoremap <expr><cr>    pumvisible() ? "\<c-y>\<cr>" : "\<cr>"
inoremap <expr><tab>   pumvisible() ? "\<c-n>" : "\<tab>"
inoremap <expr><s-tab> pumvisible() ? "\<c-p>" : "\<s-tab>"

imap <silent> <c-u>      <plug>(coc-snippets-expand)

nmap <silent> <leader>ld <plug>(coc-definition)zv
nmap <silent> <leader>lr <plug>(coc-references)
nmap <silent> <leader>lt <plug>(coc-type-definition)
nmap <silent> <leader>la <plug>(coc-codeaction-selected)
xmap <silent> <leader>la <plug>(coc-codeaction-selected)
nmap <silent> <leader>lc :<c-u>CocCommand<cr>
nmap <silent> <leader>lk :<c-u>call CocAction('doHover')<cr>

nmap <silent> <leader>lp <plug>(coc-diagnostic-prev)
nmap <silent> <leader>ln <plug>(coc-diagnostic-next)
nmap <silent> <leader>li <plug>(coc-diagnostic-info)
nmap <silent> <leader>ll :<c-u>CocDiagnostics<cr>

nmap <silent> <leader>= <plug>(coc-calc-result-replace)
