if exists('b:did_after_syntax_vim') | finish | endif
let b:did_after_syntax_vim = 1

syntax region vimSet
      \ matchgroup=vimCommand
      \ start="\<CompilerSet\!\?\>"
      \ end="$"
      \ matchgroup=vimNotation
      \ end="<[cC][rR]>"
      \ keepend
      \ oneline
      \ contains=vimSetEqual,vimOption,vimErrSetting,vimComment,vimSetString,vimSetMod

unlet b:current_syntax
syntax include @vimClusterLua syntax/lua.vim
let b:current_syntax = 'vim'

syntax region vimLua
      \ matchgroup=vimEOF
      \ start="^lua\s*<<\s*EOF$"
      \ end="^EOF"
      \ contains=@vimClusterLua,vimEOF
      \ keepend
highlight default link vimEOF PreProc

syntax sync fromstart
