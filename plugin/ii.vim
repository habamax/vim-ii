vim9script

if exists('g:loaded_vim_ii')
    finish
endif
g:loaded_vim_ii = 1

g:ii_path = get(g:, "ii_path", "~/irc")
g:ii_nick = get(g:, "ii_nick", $USER)
g:ii_filter_rx = get(g:, "ii_filter_rx", [])
g:ii_tail_n = get(g:, "ii_tail_n", 100)

import autoload 'ii.vim'

command! -nargs=+ -complete=custom,ii.Complete IIJoin ii.Join(<f-args>)
