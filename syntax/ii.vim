vim9script

if exists("b:current_syntax")
    finish
endif

syn match iiTime "^\S\{3} \d\{1,2} \d\d:\d\d" nextgroup=iiMyNick,iiNick,iiChanMsg,iiAction skipwhite
syn match iiNick "<\S\+>"
exe $'syn match iiMyNick "<{g:ii_nick}>"'
syn match iiPrompt "^\S\+>"
syn match iiChanMsg "-!-\s.*$"
syn match iiAction "\*\*\*\s.*$"

hi def link iiNick Type
hi def link iiMyNick Constant
hi def link iiPrompt Special
hi def link iiTime Comment
hi def link iiChanMsg Comment
hi def link iiAction PreProc

b:current_syntax = "ii"
