" ---------------------------------------------------------------------------
" Set vimhome
" ---------------------------------------------------------------------------
if has('win32') || has('win64')
    let $VIMHOME = $VIM."/vimfiles"
elseif has('nvim') && exists("$XDG_CONFIG_HOME")
    let $VIMHOME = $XDG_CONFIG_HOME . '/nvim'
elseif has('nvim') && !exists("$XDG_CONFIG_HOME")
    let $VIMHOME = $HOME . '/.config/nvim'
else
    let $VIMHOME = $HOME . "/.vim"
endif

source $VIMHOME/conf.d/general.vim
source $VIMHOME/conf.d/python.vim
source $VIMHOME/conf.d/vimplug.vim
source $VIMHOME/conf.d/colors.vim
