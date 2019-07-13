#!/usr/bin/env zsh

if [ -f "$HOME/.zsh_dotfiles_init" ]
then
    source "$HOME/.zsh_dotfiles_init"
else
    echo "Could not find '$HOME/.zsh_dotfiles_init'!"
    echo "Execute over-all install script!"
    exit 1
fi
source "$DOTFILES_DIR/lib/functions.zsh"

if $DOTFILES_MINIMAL
then
    echo "Minimal installation. Skipping ASDF"
    exit 0
fi

ASDF_VERSION="0.7.2"
PYTHON_VERSION="3.7.4"
NODEJS_VERSION="12.6.0"
GOLANG_VERSION="1.12.7"
JAVA_VERSION="openjdk-11"
CLOJURE_VERSION="1.10.1"

git_clone_or_pull https://github.com/asdf-vm/asdf.git $HOME/.asdf --branch "v$ASDF_VERSION"

if [ -d "$HOME/.asdf" ]; then
   source "$HOME/.asdf/asdf.sh"

   # Python is required by many neovim plugins
   asdf_install_global python $PYTHON_VERSION

   # Nodejs is required by a frew neovim plugin
   asdf_install_global nodejs $NODEJS_VERSION

   if [ "$WITH_GO" = true ]; then
       asdf_install_global golang $GOLANG_VERSION
   fi
   if [ "$WITH_JAVA" = true ]; then
       asdf_install_global java $JAVA_VERSION
   fi
   if [ "$WITH_CLJ" = true ]; then
       asdf_install_global java $JAVA_VERSION
       asdf_install_global clojure $CLOJURE_VERSION

       CLOJURE_HOME="$HOME/.clojure"
       mkdir -p $CLOJURE_HOME
       link_file "$DOTFILES_DIR/asdf/clojure/deps.edn" "$CLOJURE_HOME/deps.edn"

       mkdir -p "$HOME/bin"
       curl https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein -o $HOME/bin/lein
       chmod +x $HOME/bin/lein
       LEIN_HOME="$HOME/.lein"
       mkdir -p $LEIN_HOME
       link_file "$DOTFILES_DIR/asdf/leiningen/profiles.clj" "$LEIN_HOME/profiles.clj"
   fi

fi

