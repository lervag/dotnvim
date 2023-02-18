if exists('b:current_syntax')
  finish
endif
let b:current_syntax = 1

" Ensure syntax at top of buffer window is correct
syntax sync minlines=100

" Set spell option
syntax spell default

" Standard syntax elements
syntax match date    /^\d\d\d\d-\d\d-\d\d/
syntax match entries /^  .*/                    contains=error,number
syntax match entries /^  \(La meg\|Sto opp\).*/ contains=error,time
syntax match entries /^  Trening.*/             contains=trening

syntax match are        /^  Are/
syntax match areentries /^    \(Sto opp\|Dupp\|Mat\|La seg\|\s*\).*/ contains=error,number,time

syntax match error   /[0-9x]\+.[0-9x]\+.*/         contained
syntax match time    /[0-9][0-9]:[0-9][0-9]/       contained
syntax match number  /[0-9]\+\.[0-9]\+\( \w\+\)\?/ contained
syntax match trening /\%>17c.*/                    contained

" Syntax regions
syntax region gullkorn matchgroup=entries start=/^  Gullkorn\s\+/ end=/^\ze \w\+/ contains=@Spell
syntax region snop     matchgroup=entries start=/^  Snop\s\+/     end=/^\ze \w\+/ contains=@Spell
syntax region notat    matchgroup=entries start=/^  Notat\s\+/    end=/^$/        contains=@Spell

" Define fold regions
syntax region fold start=/^\d\d\d\d-\d\d-\d\d/ end=/^$/ transparent fold

" Set colors
highlight link date    MoreMsg
highlight link entries Statement
highlight link time    number
highlight link numbers number
highlight link unit    number

highlight link are     entries
highlight def areentries guifg=black
