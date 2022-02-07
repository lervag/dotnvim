" Note: See also ~/.config/nvim/ftplugin/tex.vim

let g:vimtex_compiler_silent = 1
let g:vimtex_complete_bib = {
      \ 'simple' : 1,
      \ 'menu_fmt' : '@year, @author_short, @title',
      \}
let g:vimtex_context_pdf_viewer = 'zathura'
let g:vimtex_doc_handlers = ['vimtex#doc#handlers#texdoc']
let g:vimtex_echo_verbose_input = 0
let g:vimtex_fold_enabled = 1
let g:vimtex_fold_types = {
      \ 'markers' : {'enabled': 0},
      \ 'sections' : {'parse_levels': 1},
      \}
let g:vimtex_format_enabled = 1
let g:vimtex_imaps_leader = '¨'
let g:vimtex_imaps_list = [
      \ { 'lhs' : 'ii', 'rhs' : '\item ', 'leader'  : '',
      \   'wrapper' : 'vimtex#imaps#wrap_environment',
      \   'context' : ['itemize', 'enumerate', 'description'] },
      \ { 'lhs' : '.',  'rhs' : '\cdot' },
      \ { 'lhs' : '*',  'rhs' : '\times' },
      \ { 'lhs' : 'a',  'rhs' : '\alpha' },
      \ { 'lhs' : 'r',  'rhs' : '\rho' },
      \ { 'lhs' : 'p',  'rhs' : '\varphi' },
      \]
let g:vimtex_quickfix_open_on_warning = 0
let g:vimtex_quickfix_ignore_filters = [
      \ 'Generic hook',
      \]
let g:vimtex_syntax_conceal_disable = 1
let g:vimtex_toc_config = {
      \ 'split_pos' : 'full',
      \ 'mode' : 2,
      \ 'fold_enable' : 1,
      \ 'hotkeys_enabled' : 1,
      \ 'hotkeys_leader' : '',
      \ 'refresh_always' : 0,
      \}
let g:vimtex_view_automatic = 0
let g:vimtex_view_forward_search_on_start = 0
let g:vimtex_view_method = 'zathura'

set spelllang=en_gb
let g:vimtex_grammar_vlty = {
      \ 'lt_command': 'languagetool',
      \ 'show_suggestions': 1,
      \}

augroup init_vimtex
  autocmd!
  autocmd User VimtexEventViewReverse normal! zMzvzz
augroup END
