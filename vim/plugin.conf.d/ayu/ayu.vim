if !dotfiles#plugin#selected('ayu-vim') || exists('g:did_cfg_ayu')
    finish
endif
let g:did_cfg_ayu = 1

if $DOTFILES_COLOR_PROFILE == 'light'
    let ayucolor='light'
else
    let ayucolor='mirage'
endif
colorscheme ayu
