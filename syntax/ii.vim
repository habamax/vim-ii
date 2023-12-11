vim9script

if exists("b:current_syntax")
    finish
endif

syn match iiTime "^\S\{3} \d\{1,2} \d\d:\d\d <\S\+>" contains=iiMyNick,iiNick nextgroup=iiChanMsg,iiAction,iiMessage skipwhite
syn match iiNick "<\S\+>" contained
exe $'syn match iiMyNick "<{g:ii_nick}>"'
exe $'syn match iiMyNick "\<{g:ii_nick}\>"'
syn match iiPrompt "^\S\+>"
syn match iiChanMsg "^\S\{3} \d\{1,2} \d\d:\d\d -!-\s.*$"
syn match iiAction "^\S\{3} \d\{1,2} \d\d:\d\d \*\*\* <\S\+>.*$"

hi def link iiNick Type
hi def link iiMyNick Statement
hi def link iiTime Comment
hi def link iiChanMsg Comment
hi def link iiAction PreProc
hi def link iiPrompt Constant

b:current_syntax = "ii"
