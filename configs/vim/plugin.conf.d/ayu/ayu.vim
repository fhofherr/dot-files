if !dotfiles#plugin#selected('ayu-vim') || exists('g:did_cfg_ayu')
    finish
endif
let g:did_cfg_ayu = 1

let ayucolor='light'

colorscheme ayu
