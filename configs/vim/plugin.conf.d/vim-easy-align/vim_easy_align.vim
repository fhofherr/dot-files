if !dotfiles#plugin#load_config('vim-easy-align') || exists('g:did_cfg_vim_easy_align')
    finish
endif
let g:did_cfg_vim_easy_align = 1

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)
