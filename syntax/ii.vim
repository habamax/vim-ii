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

syn match iiBold "[,_.!?<>(){}\-+=[:space:]]\zs\*[^*[:space:][:punct:]].\{-}[^*[:space:][:punct:]]\*\ze\([,_.!?<>(){}\-+=[:space:]]\|$\)"
syn match iiBold "[,_.!?<>(){}\-+=[:space:]]\zs\*[^*[:space:][:punct:]]\*\ze\([,_.!?<>(){}\-+=[:space:]]\|$\)"
syn match iiItalic "[,*.!?<>(){}\-+=[:space:]]\zs_[^_[:space:][:punct:]].\{-}[^_[:space:][:punct:]]_\ze\([,*.!?<>(){}\-+=[:space:]]\|$\)"
syn match iiItalic "[,*.!?<>(){}\-+=[:space:]]\zs_[^_[:space:][:punct:]]_\ze\([,*.!?<>(){}\-+=[:space:]]\|$\)"

hi def link iiNick Type
hi def link iiMyNick Statement
hi def link iiTime Comment
hi def link iiChanMsg Comment
hi def link iiAction PreProc
hi def link iiPrompt Constant
hi def iiItalic term=italic cterm=italic gui=italic
hi def iiBold term=bold cterm=bold gui=bold

b:current_syntax = "ii"
