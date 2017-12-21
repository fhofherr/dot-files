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

## Clojure plugins

The various [Clojure](http://clojure.org) plugins in this config require
the following [Leiningen](http://leiningen.org) configuration in
`~/.lein/profiles.clj`. The versions listed below may be outdated.

```clojure
{:user {:plugins [[lein-ancient "0.6.7"]
                  [lein-cloverage "1.0.6"]
                  [cider/cider-nrepl "0.8.2"]]}}
```

## FZF

Install [FZF](https://github.com/junegunn/fzf) as described in its
README.

If you are using Homebrew

```bash
brew install fzf

# To install useful key bindings and fuzzy completion:
$(brew --prefix)/opt/fzf/install
```

## MacVim

```bash
brew install macvim --with-override-system-vi
brew linkapps macvim
```
