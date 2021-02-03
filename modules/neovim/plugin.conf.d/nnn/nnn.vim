if !dotfiles#plugin#selected('nnn.vim') || exists('g:did_cfg_nnn')
    finish
endif
let g:did_cfg_nnn = 1

let g:nnn#set_default_mappings = 0

noremap <leader>d :NnnPicker<CR>
noremap <leader>D :NnnPicker %:p:h<CR>
