if !dotfiles#plugin#selected('onehalf') || exists('g:did_cfg_onehalf')
    finish
endif
let g:did_cfg_onehalf = 1

colorscheme onehalflight
