if !dotfiles#plugin#selected('vim-sneak') || exists('g:did_cfg_sneak')
    finish
endif
let g:did_cfg_sneak = 1

let g:sneak#label = 1
