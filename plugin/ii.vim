vim9script

# ii should be up and running, we should be able to
# - view and post to existing channels
# - join new channels in existing server

g:ii_nick = "habamax"
g:ii_filter_rx = ['-!-.*has joined']

import autoload 'ii.vim'

# TODO: add autocompletion for both existing servers and channels
command! -nargs=+ IIJoin ii.Join(<f-args>)

# :IIJoin irc.libera.chat #testhaba
# :IIJoin irc.libera.chat #emacs

# ii.Join("irc.libera.chat", "#testhaba")
# ii.Join("irc.libera.chat", "#emacs")
# ii.Join("irc.libera.chat", "#vim")
