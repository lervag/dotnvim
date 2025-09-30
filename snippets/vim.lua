local function autoload_name()
  ---@type string
  local au_path = vim.fn
    .matchstr(vim.fn.expand "%:p", [[\v(^|\/)autoload\/\zs.*\ze(\.\w+$)]])
    :gsub("/", "#")

  if #au_path > 0 then
    return au_path .. "#${1:name}"
  else
    return "${1:Name}"
  end
end

local function snp_function()
  return {
    prefix = "fun",
    desc = "Regular function",
    body = {
      "function! " .. autoload_name() .. "($2) abort",
      "  $0",
      "endfunction",
      "",
    },
  }
end

local snippets = {
  snp_function,
  {
    prefix = "sfun",
    desc = "Private function",
    body = {
      "function! s:${1:name}($2) abort",
      "  $0",
      "endfunction",
      "",
    },
  },
  {
    prefix = "template-vimtex",
    desc = "Template: Minimal init.vim for VimTeX",
    body = [[
set nocompatible
set runtimepath^=~/.local/plugged/vimtex
set runtimepath+=~/.local/plugged/vimtex/after
filetype plugin indent on
syntax enable

nnoremap q :qall!<cr>

let g:vimtex_view_method = "zathura"
let g:vimtex_cache_root = "."
let g:vimtex_cache_persistent = v:false

silent edit test.tex
]],
  },
  {
    prefix = "template-wiki",
    desc = "Template: Minimal init.vim for wiki.vim",
    body = [[
set nocompatible
set runtimepath^=~/.local/plugged/wiki.vim
filetype plugin indent on
syntax enable

nnoremap q :qall!<cr>

let g:wiki_root = fnamemodify("wiki", ':p')
let g:wiki_cache_root = "."
let g:wiki_cache_persistent = v:false

runtime plugin/wiki.vim
WikiIndex
]],
  },
}

return snippets
