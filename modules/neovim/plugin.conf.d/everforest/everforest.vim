if !dotfiles#plugin#selected('everforest') || exists('g:did_cfg_everforest')
    finish
endif
let g:did_cfg_everforest = 1

let g:everforest_transparent_background = 1
if $DOTFILES_COLOR_SCHEME =~ 'hard'
    let g:everforest_background = 'hard'
elseif $DOTFILES_COLOR_SCHEME =~ 'medium'
    let g:everforest_background = 'medium'
else
    let g:everforest_background = 'soft'
endif

if $DOTFILES_COLOR_SCHEME =~ 'everforest-dark'
    set background=dark
    colorscheme everforest
endif

if $DOTFILES_COLOR_SCHEME =~ 'everforest-light'
    set background=light
    colorscheme everforest
endif
