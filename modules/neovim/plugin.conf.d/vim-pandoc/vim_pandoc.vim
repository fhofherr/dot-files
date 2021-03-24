if !dotfiles#plugin#selected('vim-pandoc') || exists('g:did_cfg_pandoc')
    finish
endif
let g:did_cfg_pandoc = 1
