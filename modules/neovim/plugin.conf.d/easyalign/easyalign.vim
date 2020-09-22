if !dotfiles#plugin#selected('vim-easy-align') || exists('g:did_cfg_easyalign')
    finish
endif
let g:did_cfg_easyalign = 1

" Start interactive EasyAlign in visual mode (e.g. vip<Enter>)
vmap <Enter> <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)
