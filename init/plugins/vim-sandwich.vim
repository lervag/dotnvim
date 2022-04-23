let g:sandwich_no_default_key_mappings = 1
let g:operator_sandwich_no_default_key_mappings = 1
let g:textobj_sandwich_no_default_key_mappings = 1

" Support for python like function names
let g:sandwich#magicchar#f#patterns = [
  \   {
  \     'header' : '\<\%(\h\k*\.\)*\h\k*',
  \     'bra'    : '(',
  \     'ket'    : ')',
  \     'footer' : '',
  \   },
  \ ]


try
  " Change some default options
  call operator#sandwich#set('delete', 'all', 'highlight', 0)
  call operator#sandwich#set('all', 'all', 'cursor', 'keep')

  " Surround mappings (similar to surround.vim)
  nmap gs  <plug>(operator-sandwich-add)
  nmap gss <plug>(operator-sandwich-add)iW
  nmap ds  <plug>(operator-sandwich-delete)<plug>(textobj-sandwich-query-a)
  nmap dss <plug>(operator-sandwich-delete)<plug>(textobj-sandwich-auto-a)
  nmap cs  <plug>(operator-sandwich-replace)<plug>(textobj-sandwich-query-a)
  nmap css <plug>(operator-sandwich-replace)<plug>(textobj-sandwich-auto-a)
  xmap sa  <plug>(operator-sandwich-add)
  xmap sd  <plug>(operator-sandwich-delete)
  xmap sr  <plug>(operator-sandwich-replace)

  " Text objects
  xmap is  <plug>(textobj-sandwich-query-i)
  xmap as  <plug>(textobj-sandwich-query-a)
  omap is  <plug>(textobj-sandwich-query-i)
  omap as  <plug>(textobj-sandwich-query-a)
  xmap iss <plug>(textobj-sandwich-auto-i)
  xmap ass <plug>(textobj-sandwich-auto-a)
  omap iss <plug>(textobj-sandwich-auto-i)
  omap ass <plug>(textobj-sandwich-auto-a)

  " Allow repeats while keeping cursor fixed
  silent! runtime autoload/repeat.vim
  nmap . <plug>(operator-sandwich-predot)<plug>(RepeatDot)

  " Default recipes
  let g:sandwich#recipes  = deepcopy(g:sandwich#default_recipes)
  let g:sandwich#recipes += [
        \ {
        \   'buns' : ['{\s*', '\s*}'],
        \   'input' : ['}'],
        \   'kind' : ['delete', 'replace', 'auto', 'query'],
        \   'regex' : 1,
        \   'nesting' : 1,
        \   'match_syntax' : 1,
        \   'skip_break' : 1,
        \   'indentkeys-' : '{,},0{,0}'
        \ },
        \ {
        \   'buns' : ['\[\s*', '\s*\]'],
        \   'input' : [']'],
        \   'kind' : ['delete', 'replace', 'auto', 'query'],
        \   'regex' : 1,
        \   'nesting' : 1,
        \   'match_syntax' : 1,
        \   'indentkeys-' : '[,]'
        \ },
        \ {
        \   'buns' : ['(\s*', '\s*)'],
        \   'input' : [')'],
        \   'kind' : ['delete', 'replace', 'auto', 'query'],
        \   'regex' : 1,
        \   'nesting' : 1,
        \   'match_syntax' : 1,
        \   'indentkeys-' : '(,)'
        \ },
        \]
catch
endtry
