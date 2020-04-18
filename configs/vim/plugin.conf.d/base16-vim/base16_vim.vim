if exists('g:did_cfg_base16_vim') || !dotfiles#plugin#selected('base16-vim')
    finish
endif
let g:did_cfg_base16_vim = 1

" let base16colorspace=256

if filereadable(expand("~/.vimrc_background"))
    source ~/.vimrc_background
else
    let s:theme_name = $DOTFILES_COLOR_THEME
    execute 'colorscheme '.s:theme_name
endif
