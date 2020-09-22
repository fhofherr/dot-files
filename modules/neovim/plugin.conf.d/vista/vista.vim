if !dotfiles#plugin#selected('vista.vim') || exists('g:did_cfg_vista_vim')
    finish
endif
let g:did_cfg_vista_vim = 1

let g:vista_close_on_jump = 1

nmap <silent> <F12> :Vista!!<cr>
