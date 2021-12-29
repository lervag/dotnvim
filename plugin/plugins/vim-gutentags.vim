let g:gutentags_define_advanced_commands = 1
let g:gutentags_cache_dir = expand('~/.cache/nvim/ctags/')
let g:gutentags_ctags_extra_args = [
      \ '--tag-relative=yes',
      \ '--fields=+aimS',
      \ ]
let g:gutentags_file_list_command = {
      \ 'markers': {
      \   '.git': 'git ls-files',
      \   '.hg': 'hg files',
      \ },
      \}
