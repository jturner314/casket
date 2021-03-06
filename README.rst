######
Casket
######

Casket is a small shell script to manage encrypted `LUKS`_ containers. It is
useful when you want to encrypt a directory but still be able to easily work
with the files in the directory, such as for keeping your financial records.

Its primary goal is to be a simpler and easier-to-audit alternative to `Tomb`_.
It is less than 300 lines, and it uses minimal features of the shell to make it
easy-to-understand without significant shell knowledge.

.. _LUKS: https://gitlab.com/cryptsetup/cryptsetup/blob/master/README.md

Casket is missing many of Tomb's features and has much less polish. If you want
those features, don't care about understanding how your encryption script
works, trust Tomb, or are willing to spend the time to audit the source of
Tomb, then use `Tomb`_. Otherwise, consider using Casket for its simplicity.

.. _Tomb: https://www.dyne.org/software/tomb

Installation
============

Download this repository, then run::

  sudo make install

in the downloaded directory.

Usage
=====

Please read the source of Casket to learn how it works before using it.

You should run Casket as the user you want to read/write the opened container.
Casket uses ``sudo`` to perform individual operations that need root
permissions so that you do not have to run the entire script as root.

If any command fails during Casket's execution, Casket will exit immediately
without cleaning up. Use ``casket status`` to list things that you can clean up
manually. (Restarting your computer is also sufficient.)

Run Casket like this::

  casket create <path> <size>
  casket open <path> [mountpoint]
  casket close <name>
  casket list
  casket status

where the arguments are:

``<path>``
    path to casket file

``<size>``
    size of casket file in MiB

``[mountpoint]``
    optional mount point for open casket (default: ``<path>_mounted``)

``<name>``
    mapper name of an open casket file, or ``all`` for all opened caskets

and the commands are:

``create``
    Create a new casket of the specified size at the specified path.

``open``
    Open the casket located at the specified path.

``close``
    Close the casket with the specified mapper name, or ``all`` to close all
    open caskets. Use the ``list`` command to list the mapper names of open
    caskets.

``list``
    List the mapper names of all open caskets.

``status``
    List the mounted casket filesystems, open casket containers, and all loop
    devices. This is helpful if Casket exits early and you need to clean up.

Security Properties
===================

Casket works by attaching a file as a loop device, encrypting that device with
`LUKS`_, and mounting an ext4 filesystem in the LUKS container. If:

* the attacker has never had access to your computer before,
* the computer has been off for at least a few minutes,
* the attacker has never observed you typing your passphrase,
* you used a strong passphrase, and
* the attacker is not able to `coerce you`_ into giving him/her the passphrase,

.. _coerce you: `Coercion`_

you can be reasonably sure that he/she cannot feasibly read your files in
Casket containers. If any of those conditions are not met (and possibly under
other circumstances as well), the attacker may be able to read your files.
These are some example attacks that he/she could use when those conditions
aren't met:

* Surveillance while you're typing your passphrase (including someone watching
  over your shoulder, cameras watching your keyboard, and
  `TEMPEST-style attacks`_)
* `Trojan horse malware`_
* `DMA attacks`_
* `Evil maid attacks`_
* `Cold boot attacks`_
* `Coercion`_
* etc.

.. _TEMPEST-style attacks: https://en.wikipedia.org/wiki/Tempest_(codename)
.. _Trojan horse malware: https://en.wikipedia.org/wiki/Trojan_horse_(computing)
.. _DMA attacks: https://en.wikipedia.org/wiki/DMA_attack
.. _Evil maid attacks: https://www.schneier.com/blog/archives/2009/10/evil_maid_attac.html
.. _Cold boot attacks: https://en.wikipedia.org/wiki/Cold_boot_attack
.. _Coercion: https://xkcd.com/538/

Keep in mind that only data in your Casket containers are protected. While the
containers are open, various programs may save information about the contents
of the container outside of the container. For example, the thumbnailer may
save thumbnails of images that you look at with your file browser, or the
indexing daemons of search tools may save metadata about the files.

Known Issues
============

These are known issues with Casket. Please create a GitHub issue or pull
request if you have a solution!

* The mode of the mount point created by the ``mount`` command is not
  consistent, despite the ``x-mount.mkdir=0700`` option, and in some cases is
  ``0755``. Casket sets the mode to ``0700`` immediately after running
  ``mount``, but there is a brief period during which the mode of the mount
  point is that selected by ``mount``.

Frequently Asked Questions
==========================

How do I generate a secure passphrase?
--------------------------------------

If you want an easy-to-remember but strong passphrase, I recommend using the
`Diceware`_ generation technique. If you don't care about remembering it, then
generate a long, random passphrase in your password manager. (See
``cryptsetup --help`` for the maximum allowed passphrase length.)

.. _Diceware: http://world.std.com/~reinhold/diceware.html

Why not just use GPG?
---------------------

GPG is great for working with individual files and sending emails, but it does
not work well when working with a directory of files. Of course, you can tar
the files and encrypt the archive with GPG, but then you have to decrypt the
entire archive when you want to access a single file (which can be very slow
for large archives), and this technique encourages placing decrypted files
temporarily on your hard drive while you're working with them. In contrast,
Casket uses the Linux device mapper and block encryption facilities to
transparently perform the encryption so that you don't have to decrypt the
entire container to use one file, and you can work with the files like a normal
directory without ever placing unencrypted copies on your hard drive.

License
=======

Copyright (C) 2015  Jim Turner <casket@turner.link>

This file is part of Casket.

Casket is free software: you can redistribute it and/or modify it under the
terms of the GNU General Public License as published by the Free Software
Foundation, either version 3 of the License, or (at your option) any later
version.

Casket is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with
Casket. If not, see <http://www.gnu.org/licenses/>.
