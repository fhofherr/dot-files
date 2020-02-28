if !dotfiles#plugin#selected('base16-vim') || exists('g:did_cfg_base16_vim')
    finish
endif
let g:did_cfg_base16_vim = 1

let s:theme_name = $DOTFILES_COLOR_THEME
if $DOTFILES_COLOR_PROFILE == 'light'
    let s:theme_name = s:theme_name . '-light'
endif

if $DOTFILES_COLOR_BASE16_256MODE == 'true'
    let base16colorspace=256
endif

execute 'colorscheme '.s:theme_name
