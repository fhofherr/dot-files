# README

This is my vim configuration. There are many vim configurations, but
this is mine! ... :-)

It contains mostly stuff I copied from some obscure corners of the
Internet. It is probably of little use to you, but hosting it in github
is of great use to me.

# Installation

## MacVim with Python3 support

```bash
brew install macvim --with-python3
```

## NeoVim

```bash
brew install neovim
```

## Setup

Execute `./install.py`. 

## Manual Setup

### Clojure plugins

The various [Clojure](http://clojure.org) plugins in this config require
the following [Leiningen](http://leiningen.org) configuration in
`~/.lein/profiles.clj`. The versions listed below may be outdated.

```clojure
{:user {:plugins [[lein-ancient "0.6.7"]
                  [lein-cloverage "1.0.6"]
                  [cider/cider-nrepl "0.8.2"]]}}
```

### FZF

Install [FZF](https://github.com/junegunn/fzf) as described in its
README.

If you are using Homebrew

```bash
brew install fzf

# To install useful key bindings and fuzzy completion:
$(brew --prefix)/opt/fzf/install
```

### The Silver Searcher

To use [The Silver Searcher](https://github.com/ggreer/the_silver_searcher)
with [Ack.vim](https://github.com/mileszs/ack.vim) you have to install
it.

```bash
brew install the_silver_searcher
```
