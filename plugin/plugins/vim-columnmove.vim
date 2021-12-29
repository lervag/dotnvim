let g:columnmove_no_default_key_mappings = 1

for s:x in split('ftFT;,wbeWBE', '\zs') + ['ge', 'gE']
  silent! call columnmove#utility#map('nxo', s:x, 'ø' . s:x, 'block')
endfor
unlet s:x
