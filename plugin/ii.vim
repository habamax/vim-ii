vim9script

g:ii_nick = get(g:, "ii_nick", $USER)
g:ii_filter_rx = get(g:, "ii_filter_rx", [])

import autoload 'ii.vim'

# TODO: add autocompletion for both existing servers and channels
command! -nargs=+ IIJoin ii.Join(<f-args>)

# :II /j #somechannel
# command! -nargs=+ II ii.Cmd(<q-args>)
