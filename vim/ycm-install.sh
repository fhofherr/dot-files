#!/bin/bash

YCM_DIR="$DOTFILES_DIR/vim/bundle/youcompleteme"

if [ ! -d "$YCM_DIR" ]
then
    echo "YouCompleteMe not downloaded"
    exit 1
fi

INSTALL_YCM="$YCM_DIR/install.py --clang-completer"

if which python3 > /dev/null
then
    INSTALL_YCM="python3 $INSTALL_YCM"
else
    INSTALL_YCM="python $INSTALL_YCM"
fi

if which go > /dev/null
then
    INSTALL_YCM="$INSTALL_YCM --go-completer"
fi

if which java > /dev/null
then
    INSTALL_YCM="$INSTALL_YCM --java-completer"
fi

if which node > /dev/null && which npm > /dev/null
then
    INSTALL_YCM="$INSTALL_YCM --js-completer"
fi

if which cargo > /dev/null
then
    INSTALL_YCM="$INSTALL_YCM --rust-completer"
fi


if which msbuild > /dev/null
then
    INSTALL_YCM="$INSTALL_YCM --cs-completer"
fi

if which brew > /dev/null
then
    mkdir -p "$YCM_DIR/third_party/ycmd"
    cat <<EOM > "$YCM_DIR/third_party/ycmd/setup.cfg"
[install]
prefix=
EOM
fi

exec $INSTALL_YCM
