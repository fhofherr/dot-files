if !dotfiles#plugin#selected('vim-colors-solarized') || exists('g:did_cfg_vim_colors_solarized')
    finish
endif
let g:did_cfg_vim_colors_solarized = 1

set background=light
colorscheme solarized
