if !dotfiles#plugin#selected('vim-maximizer') || exists('g:did_cfg_vim_maximizer')
    finish
endif
let g:did_cfg_vim_maximizer = 1

 let g:maximizer_set_mapping_with_bang = 1
 let g:maximizer_default_mapping_key = '<F3>'
