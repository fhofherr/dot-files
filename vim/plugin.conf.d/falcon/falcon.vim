if !dotfiles#plugin#selected('falcon') || exists('g:did_cfg_falcon')
    finish
endif
let g:did_cfg_falcon = 1

" Ensure termguicolors is set
set termguicolors

let g:falcon_background = 1
let g:falcon_inactive = 1
let g:falcon_lightline = 1

colorscheme falcon
