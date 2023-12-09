vim9script

if exists("b:current_syntax")
    finish
endif

syn match iiTime "^\d\d:\d\d" nextgroup=iiMyNick,iiNick,iiChanMsg skipwhite
syn match iiNick "<\S\+>"
exe $'syn match iiMyNick "<{g:ii_nick}>"'
syn match iiPrompt "^\S\+>"
syn match iiChanMsg "-!-\s.*$"

hi def link iiMyNick Constant
hi def link iiPrompt Special
hi def link iiTime Comment
hi def link iiNick Type
hi def link iiChanMsg Comment

b:current_syntax = "ii"
