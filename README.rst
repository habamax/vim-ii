################################################################################
                       vim-ii: suckless ii (irc) and vim
################################################################################

WIP
===

Thin integration layer over `Irc it (ii)`_ to do irc in vim.

.. image:: https://github.com/habamax/vim-ii/assets/234774/e76452f6-85ea-4a19-9530-cc8400fdb58e

.. _Irc it (ii):  https://tools.suckless.org/ii/


Quickstart
==========

Prerequisites:

- GNU/Linux -- I doubt it would work on Windows, haven't tested OSX.
- ``ii`` suckless irc client
- ``tail`` command
- ``vim9`` compiled as ``huge``


Install ``ii``
--------------

.. code:: sh

  $ git clone https://git.suckless.org/ii

Edit ``Makefile`` if you want to have a different ``PREFIX`` (I have ``PREFIX=$(HOME)/.local``).

.. code:: sh

  $ cd ii
  $ make
  $ make install

``ii`` should be installed into ``PREFIX`` dir. Make sure it is in ``PATH``.


Run ``ii``
----------

.. code::

  $ ii -s irc.libera.chat -p 6667 -n mynickname &
  $ cd ~/irc/irc.libera.chat
  $ echo "/j nickserv identify mynickname password" > in

Change ``mynickname`` and ``password`` to your own. 

The ``~/irc/irc.libera.chat`` directories will be created by ``ii`` automatically. 


Vim
---

Now when ii is up and running, connected to libera.chat, in vim do::

  :IIJoin irc.libera.chat #vim

to join ``#vim`` channel.

.. raw:: html

  <a href="https://asciinema.org/a/uh4wIwbtFURb7CBznIIkIGysv" target="_blank"><img src="https://asciinema.org/a/uh4wIwbtFURb7CBznIIkIGysv.svg" /></a>

Now you are able to send and recieve messages. 

Treat the windows as you normally do in Vim. 

For example ``C-w H`` to make the current window split, a vertical split. 

See ``:h windows`` for more information. 

Quickstart 2
============

Shell script to connect/reconnect libera
----------------------------------------

.. code:: sh

  #!/usr/bin/env sh

  # https://github.com/c00kiemon5ter/iii/blob/master/connect.sh

  : "${ircdir:=$HOME/irc}"
  : "${nick:=$USER}"

  # server info functions
  libera() {
      server='irc.libera.chat'
      channels="#vim #emacs #perl #python"
  }

  # these match the functions above
  networks="libera"

  for network in $networks; do
      unset server channels port
      "$network" # set the appropriate vars

      while true; do
          # cleanup
          rm -f "$ircdir/$server/in"
          # connect to network -- password is set through the env var synonym to the network name
          ii -i "$ircdir" -n "$nick" -k "$network" -s "$server" -p "${port:-6667}" &
          pid="$!"

          # wait for the connection
          while ! test -p "$ircdir/$server/in"; do sleep .3; done

          # auth to services either using plain password stored in ident file
          # or using pass
          if [ -e "$ircdir/$server/ident" ]
              then printf "/j nickserv identify %s\n" "$(cat "$ircdir/$server/ident")" > "$ircdir/$server/in"
          else
              printf "/j nickserv identify %s\n" "$(pass libera)" > "$ircdir/$server/in"
          fi && rm -f "$ircdir/$server/nickserv/out" # clean that up - ident passwd is in there

          # join channels
          printf "/j %s\n" $channels > "$ircdir/$server/in"

          # if connection is lost reconnect
          wait "$pid"
      done &
  done


vim command to open windows with 4 channels
-------------------------------------------

.. code:: vim

  vim9script

  def Irc()
      exe "IIJoin irc.libera.chat #vim"
      wincmd o
      exe "IIJoin irc.libera.chat #python"
      wincmd L
      exe "IIJoin irc.libera.chat #perl"
      wincmd h
      exe "IIJoin irc.libera.chat #emacs"
  enddef
  command! Irc Irc()
