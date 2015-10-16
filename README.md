# README

This is my vim configuration. There are many vim configurations, but
this is mine! ... :-)

It contains mostly stuff I copied from some obscure corners of the
Internet. It is probably of little use to you, but hosting it in github
is of great use to me.

# Installation

```bash
ln -s  $PWD/myvimcfg/vimrc $HOME/.vimrc
ln -s  $PWD/myvimcfg/gvimrc $HOME/.gvimrc
ln -s  $PWD/myvimcfg $HOME/.vim

cd $PWD/myvimcfg
git submodule update --init
```

After that start vim and call `:PluginInstall`

## YouCompleteMe

The YouCompleteMe plugin has a compiled component. I usually call its
`install.py` script with the following arguments:

```bash
./install.py --clang-completer --gocode-completer
```
