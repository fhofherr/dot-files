" ---------------------------------------------------------------------------
"
" localvimrc
"
" ---------------------------------------------------------------------------
if !has_key(g:plugs, 'vim-localvimrc')
    finish
endif

let g:localvimrc_persistence_file = $VIMHOME . "/.localvimrc_persistent"
let g:localvimrc_persistent = 2
