################################################################################
                       vim-ii: suckless ii (irc) and vim
################################################################################

WIP
===

Thin integration layer over ``ii`` to do irc in vim.

.. image:: https://github.com/habamax/vim-ii/assets/234774/e76452f6-85ea-4a19-9530-cc8400fdb58e


Quickstart
==========

Install ``ii``
--------------

.. code:: sh

  $ cd ~/prj
  $ git clone git clone https://git.suckless.org/ii

Edit ``Makefile`` if you want to have a different ``PREFIX`` (I have ``PREFIX=$HOME/.local``).

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


Vim part
--------

Now when ii is up and running, connected to libera.chat, in vim do::

  :IIJoin irc.libera.chat #vim

to join ``#vim`` channel.

.. raw:: html

  <a href="https://asciinema.org/a/uh4wIwbtFURb7CBznIIkIGysv" target="_blank"><img src="https://asciinema.org/a/uh4wIwbtFURb7CBznIIkIGysv.svg" /></a>
