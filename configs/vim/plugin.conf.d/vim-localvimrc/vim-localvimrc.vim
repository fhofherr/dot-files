" ---------------------------------------------------------------------------
"
" localvimrc
"
" ---------------------------------------------------------------------------
if !dotfiles#plugin#selected('vim-localvimrc') || exists('g:did_cfg_vim_localvimrc')
    finish
endif
let g:did_cfg_vim_localvimrc = 1

let g:localvimrc_persistence_file = $VIMHOME . "/.localvimrc_persistent"
let g:localvimrc_persistent = 2
