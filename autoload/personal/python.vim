function! personal#python#set_path()
  let &l:path = &path

  " Add standard python paths
  python3 << EOF
import os
import sys
import vim
for p in sys.path:
    # Add each directory in sys.path, if it exists.
    if os.path.isdir(p):
        # Command 'set' needs backslash before each space.
        vim.command(r"setlocal path+=%s" % (p.replace(" ", r"\ ")))
EOF

  " Add package root to path
  let path = expand('%:p:h')
  let top_level = ''
  while len(path) > 1
    if filereadable(path . '/__init__.py')
      let top_level = path
    endif
    let path = fnamemodify(path, ':h')
  endwhile

  if !empty(top_level)
    let &l:path .= ',' . top_level . '/**'
  endif
endfunction
