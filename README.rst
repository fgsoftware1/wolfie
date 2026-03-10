========
wolfieOS
========

How to build
============

This will run qemu in debug mode and also create qemu log

..  code-block:: 

    fish build.fish    

Debugging
=========

..  code-block:: 

    fish debug.fish

In another terminal/tab, run gdb manually or the following if you wanna automate it, also edit .gdbinit:

..  code-block:: 

    fish gdb.fish

