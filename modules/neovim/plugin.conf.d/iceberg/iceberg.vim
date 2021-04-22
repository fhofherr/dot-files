if !dotfiles#plugin#selected('iceberg.vim') || exists('g:did_cfg_iceberg')
    finish
endif
let g:did_cfg_iceberg = 1

if $DOTFILES_COLOR_SCHEME == 'iceberg-dark'
    set background=dark
endif
if $DOTFILES_COLOR_SCHEME == 'iceberg-light'
    set background=light
endif

colorscheme iceberg
