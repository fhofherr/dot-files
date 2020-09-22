if !dotfiles#plugin#selected('gopher.vim') || exists('g:did_cfg_gopher_vim')
    finish
endif
let g:did_cfg_gopher_vim = 1

" Disable the default gopher.vim mappings.
let g:gopher_map = 0
