vim9script

if exists("b:current_syntax")
    finish
endif

syn match iiPrefix "^\S\{3} \d\{1,2} \d\d:\d\d <\S\+>" contains=iiTime,iiMyNick,iiNick skipwhite
syn match iiTime "^\S\{3} \d\{1,2} \d\d:\d\d" contained
syn match iiNick "<\S\+>" contained
exe $'syn match iiMyNick "<{g:ii_nick}>"'
exe $'syn match iiMyNick "\<{g:ii_nick}\>"'
syn match iiPrompt "^\S\+>"
syn match iiChanMsg "^\S\{3} \d\{1,2} \d\d:\d\d -!-\s.*$"
syn match iiAction "^\S\{3} \d\{1,2} \d\d:\d\d \*\*\* <\S\+>.*$"

syn match iiBold "[[:punct:][:space:]]\zs\*\S.\{-}\S\*\ze\([[:punct:][:space:]]\|$\)"
syn match iiBold "[[:punct:][:space:]]\zs\*\S\*\ze\([[:punct:][:space:]]\|$\)"
syn match iiItalic "[[:punct:][:space:]]\zs_\S.\{-}\S_\ze\([[:punct:][:space:]]\|$\)"
syn match iiItalic "[[:punct:][:space:]]\zs_\S_\ze\([[:punct:][:space:]]\|$\)"

hi def link iiNick Type
hi def link iiMyNick Statement
hi def link iiTime Comment
hi def link iiChanMsg Comment
hi def link iiAction PreProc
hi def link iiPrompt Constant
hi def iiItalic term=italic cterm=italic gui=italic
hi def iiBold term=bold cterm=bold gui=bold

b:current_syntax = "ii"
