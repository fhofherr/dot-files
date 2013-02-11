======
README
======

This is my vim configuration. There are many vim configurations, but
this is mine! ... :-)

It contains mostly stuff I copied from some obscure corners of the
Internet. It is probably of little use to you, but hosting it in github
is of great use to me.

Plugins
=======

I'm using *pathogen.vim* to manage the plugins I use. They are all
located in the *bundles* directory, and are git submodules. To
initialize the submodules after cloning this repository execute::

  git submodule init
  git submodule foreach git submodule init

After that, or to update all plugins execute::

  git submodule update
  git submodule foreach git submodule update

Plugin specific instructions
----------------------------

Command-T
~~~~~~~~~

Command-T has some parts that need to be compiled. Execute::

    cd bundle/command-t
    rake make

Note that this needs the `ruby-dev` installed! Under Debian/Ubuntu execute::

    sudo aptitude install ruby-dev

Syntastic
~~~~~~~~~

Syntastic requires a few addtional executables to work. Python syntax checking
for example requires at least one of `flake8`, `pyflakes`, `pylint` or
`python` to be on the path. If nothing is found on the path no syntax checking
will take place. You can install the executables in a virtual environment. See
the syntastic documentation for further information.

Installation
============

After initializing and updating the plugins it is enough to create three
symlinks:

* Link myvimcfg/vimrc to $HOME/.vimrc
* Link myvimcfg/gvimrc to $HOME/.gvimrc
* Link myvimcfg to $HOME/.vim
