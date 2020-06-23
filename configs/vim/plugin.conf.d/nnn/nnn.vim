if !dotfiles#plugin#selected('nnn.vim') || exists('g:did_cfg_nnn_vim')
    finish
endif
let g:did_cfg_nnn_vim = 1

let g:nnn#command = 'nnn -e'
let g:nnn#set_default_mappings = 0

let g:nnn#action = {
      \ '<c-t>': 'tab split',
      \ '<c-x>': 'split',
      \ '<c-v>': 'vsplit'
      \}

nnoremap <silent> <leader>d :NnnPicker<CR>
nnoremap <silent> <leader>D :NnnPicker '%:p:h'<CR>
