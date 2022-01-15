if exists('g:init_coq_loaded') | finish | endif
let g:init_coq_loaded = 1

let g:coq_settings = {
      \ 'auto_start': 'shut-up',
      \ 'keymap.pre_select': v:true,
      \ 'display.ghost_text.enabled': v:true,
      \ 'display.ghost_text.context': ["", ""],
      \ 'display.icons.mode': 'short',
      \ 'display.pum.fast_close': v:false,
      \}
