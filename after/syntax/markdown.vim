if exists('b:did_after_syntax_markdown') | finish | endif
let b:did_after_syntax_markdown = 1

syntax match mkdEnvvar "\$\w\{2,}"
syntax region texMathZoneMD matchgroup=texMathDelimZone
      \ start="\[\$\]"
      \ end="\[\/\$\]"
      \ contains=@texClusterMath
      \ keepend
syntax region texMathZoneMD matchgroup=texMathDelimZone
      \ start="\[\$\$\]"
      \ end="\[\/\$\$\]"
      \ contains=@texClusterMath
      \ keepend

syntax cluster mkdNonListItem add=mkdEnvvar,texMathZoneMD

highlight default link mkdEnvvar ModeMsg
highlight default link texMathZoneMD texMathZone
