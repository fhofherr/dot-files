if !dotfiles#plugin#selected('vim-startify') || exists('g:did_cfg_startify')
    finish
endif
let g:did_cfg_startify = 1

let g:startify_session_persistence = 0
