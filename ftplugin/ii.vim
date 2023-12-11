vim9script

if exists("b:did_ftplugin")
    finish
endif

b:did_ftplugin = 1

var undo_opts = "setl buftype< buflisted< swapfile< undofile< wrap<"
undo_opts ..= " formatlistpat< formatoptions"
undo_opts ..= " breakindent< breakindentopt< linebreak<"

var undo_maps = "| execute 'iunmap <buffer> <CR>'"
undo_maps ..= " | execute 'nunmap <buffer> <CR>'"

if exists('b:undo_ftplugin')
    b:undo_ftplugin ..= "|" .. undo_opts .. undo_maps
else
    b:undo_ftplugin = undo_opts .. undo_maps
endif

setl buftype=nofile
setl buflisted
setl noswapfile
setl noundofile

setl wrap
setl breakindent
setl breakindentopt=sbr,list:-1
setl linebreak

setl formatoptions=n
setl formatlistpat=^\\S\\{3}\\s\\d\\{1,2}\\s\\d\\d:\\d\\d\\s
setl formatlistpat+=\\(
setl formatlistpat+=\\(<\\S\\+>\\s\\)
setl formatlistpat+=\\\|
setl formatlistpat+=\\(-!-\\s\\)
setl formatlistpat+=\\)

import autoload 'ii.vim'
inoremap <buffer> <CR> <scriptcmd>ii.SendMessage()<CR><ESC>GA
nnoremap <buffer> <CR> <scriptcmd>ii.Prompt(true)<CR><cmd>normal! G$<CR><cmd>startinsert!<CR>

au BufReadCmd <buffer> ii.Tail(true) | set syn=ii
