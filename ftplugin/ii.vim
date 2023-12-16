vim9script

if exists("b:did_ftplugin")
    finish
endif

b:did_ftplugin = 1

var undo_opts = "setl buftype< buflisted< swapfile< undofile< wrap<"
undo_opts ..= " formatlistpat< formatoptions<"
undo_opts ..= " breakindent< breakindentopt< linebreak<"

var undo_maps = "| execute 'iunmap <buffer> <CR>'"
undo_maps ..= " | execute 'iunmap <buffer> <C-u>'"
undo_maps ..= " | execute 'iunmap <buffer> <C-w>'"
undo_maps ..= " | execute 'iunmap <buffer> <C-h>'"
undo_maps ..= " | execute 'iunmap <buffer> <BS>'"
undo_maps ..= " | execute 'nunmap <buffer> <CR>'"
undo_maps ..= " | execute 'nunmap <buffer> I'"
undo_maps ..= " | execute 'nunmap <buffer> A'"
undo_maps ..= " | execute 'nunmap <buffer> gI'"
undo_maps ..= " | execute 'nunmap <buffer> dd'"
undo_maps ..= " | execute 'nunmap <buffer> cc'"

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
setl formatlistpat=^\\S\\{3}\\s\\d\\{1,2}\\s\\d\\d:\\d\\d\\s\\(\\*\\{3}\\s\\)\\?
setl formatlistpat+=\\(
setl formatlistpat+=\\(<\\S\\+>\\s\\)
setl formatlistpat+=\\\|
setl formatlistpat+=\\(-!-\\s\\)
setl formatlistpat+=\\)

import autoload 'ii.vim'
import autoload 'ii/prompt.vim'
inoremap <buffer> <CR> <scriptcmd>prompt.Insert("\<lt>CR>")<CR>
nnoremap <buffer> <CR> <scriptcmd>prompt.Normal("\<lt>CR>")<CR>
inoremap <buffer> <C-u> <scriptcmd>prompt.Insert("\<C-u>")<CR>
inoremap <buffer> <C-w> <scriptcmd>prompt.Insert("\<C-w>")<CR>
inoremap <buffer> <BS> <scriptcmd>prompt.Insert("\<BS>")<CR>
inoremap <buffer> <C-h> <scriptcmd>prompt.Insert("\<C-h>")<CR>
nnoremap <buffer> I <scriptcmd>prompt.Normal("I")<CR>
nnoremap <buffer> A <scriptcmd>prompt.Normal("A")<CR>
nnoremap <buffer> gI <scriptcmd>prompt.Normal("gI")<CR>
nnoremap <buffer> dd <scriptcmd>prompt.Normal("dd")<CR>
nnoremap <buffer> cc <scriptcmd>prompt.Normal("cc")<CR>

au BufReadCmd <buffer> ii.Tail(bufnr(), true) | set syn=ii
