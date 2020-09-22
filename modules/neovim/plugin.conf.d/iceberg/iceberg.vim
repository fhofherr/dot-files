if !dotfiles#plugin#selected('iceberg.vim') || exists('g:did_cfg_iceberg')
    finish
endif
let g:did_cfg_iceberg = 1

colorscheme iceberg
